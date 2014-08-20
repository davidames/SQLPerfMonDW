CREATE PROCEDURE [dbo].[usp_CaptureWaitStats]
(
	@LogThresholdWaitCount int = 10, /* Only capture stats for waits that had >this many in the capture period.*/
	@CaptureTopPercent smallint = 100 /* Only capture the top X percentage of waits by total wait time */
)	
AS

DECLARE @CurrentWaitSnapshotId bigint,
		@PreviousWaitSnapshotId bigint,
		@PreviousWaitSnapshotDateOccured datetimeoffset,
		@CurrentSnapshotDateOccured datetimeoffset


SELECT TOP 1 @PreviousWaitSnapshotId = l.WaitSnapshotId, 
			 @PreviousWaitSnapshotDateOccured = s.DateOccured
FROM		 WaitLatestBaseline l
INNER JOIN	 WaitSnapshots s ON l.WaitSnapshotID = s.WaitSnapshotID

ORDER BY	l.WaitSnapshotId DESC

SET @CurrentSnapshotDateOccured = SysDateTimeOffset()

INSERT WaitSnapshots
(
	DurationSeconds,
	DateOccured
)
VALUES
(
	DateDiff(second, @CurrentSnapshotDateOccured, @PreviousWaitSnapshotDateOccured),
	@CurrentSnapshotDateOccured
)

SELECT @CurrentWaitSnapshotId = SCOPE_IDENTITY()

;WITH cteWaits AS
(
	SELECT		wt.WaitTypeId, ws.waiting_tasks_count, ws.wait_time_ms, ws.signal_wait_time_ms
	FROM		sys.dm_os_wait_stats ws
	INNER JOIN	WaitTypes wt ON ws.wait_type = wt.Name
	WHERE		wt.IsMonitored = 1 /* Filter out the ones we don't care about*/
)

INSERT WaitLatestBaseline
(
	WaitSnapshotId,
	WaitTypeId,
	waiting_tasks_count,
	wait_time_ms,
	signal_wait_time_ms
)

SELECT  @CurrentWaitSnapshotId,
		w.WaitTypeId,
		w.waiting_tasks_count,
		w.wait_time_ms,
		w.signal_wait_time_ms
FROM cteWaits w


INSERT FileStatsLatestBaseline
(
	WaitSnapshotId,
	io_stall,
	io_stall_read_ms,
	io_stall_write_ms,
	num_of_reads,
	num_of_writes,
	size_on_disk_mb,
	database_id,
	dbname,
	fileName,
	file_id
)
SELECT @CurrentWaitSnapshotId, a.io_stall, a.io_stall_read_ms, a.io_stall_write_ms, a.num_of_reads, 
		a.num_of_writes,  ( ( a.size_on_disk_bytes / 1024 ) / 1024.0 ), a.database_id,db_name(a.database_id) AS dbname, 
		b.name, a.file_id
FROM sys.dm_io_virtual_file_stats (NULL, NULL) a 
JOIN sys.master_files b ON a.file_id = b.file_id 
AND a.database_id = b.database_id 


INSERT Waits
(
	WaitSnapshotId,
	WaitTypeId,
	WaitingTasksCount,
	WaitTimeMs,
	SignalWaitTimeMs
)

SELECT TOP (@CaptureTopPercent) PERCENT 
			@CurrentWaitSnapshotId,
			w1.WaitTypeId,
			w2.waiting_tasks_count - w1.waiting_tasks_count,
			w2.wait_time_ms - w1.wait_time_ms,
			w2.signal_wait_time_ms - w1.signal_wait_time_ms

FROM		WaitLatestBaseline w1 
INNER JOIN  WaitLatestBaseline w2 ON w1.WaitTypeId = w2.WaitTypeId
WHERE		w1.WaitSnapshotId = @PreviousWaitSnapshotId
			AND w2.WaitSnapshotId = @CurrentWaitSnapshotId
			AND w2.waiting_tasks_count - w1.waiting_tasks_count > @LogThresholdWaitCount /* No point loging empty data!*/

ORDER BY	w2.wait_time_ms - w1.wait_time_ms DESC




INSERT FileStats
(
	WaitSnapshotId,
	io_stall,
	io_stall_read_ms,
	io_stall_write_ms,
	num_of_reads,
	num_of_writes,
	size_on_disk_mb,
	database_id,
	dbname,
	fileName,
	file_id
)
SELECT @CurrentWaitSnapshotId, a.io_stall - base.io_stall, a.io_stall_read_ms - base.io_stall_read_ms, a.io_stall_write_ms - base.io_stall_write_ms, a.num_of_reads - base.Num_Of_reads,
		a.num_of_writes - base.num_of_writes,  ( ( a.size_on_disk_bytes / 1024 ) / 1024.0 ) - base.size_on_disk_mb, a.database_id,db_name(a.database_id) AS dbname, 
		b.name, a.file_id
FROM sys.dm_io_virtual_file_stats (NULL, NULL) a 
INNER JOIN sys.master_files b ON a.file_id = b.file_id  AND a.database_id = b.database_id 
INNER JOIN FileStatsLatestBaseline base ON a.database_id = base.database_id AND a.file_id = base.file_id
WHERE base.WaitSnapshotId = @PreviousWaitSnapshotId

		    
DELETE FROM WaitLatestBaseline WHERE WaitSnapShotID < @CurrentWaitSnapshotId
DELETE FROM FileStatsLatestBaseline WHERE WaitSnapShotID < @CurrentWaitSnapshotId
CREATE FUNCTION tvf_FileAnalysisGoingBackFromLatest
(
	 @HoursToGoBack int
)
RETURNS TABLE
AS
RETURN  
(


WITH cteLastFileSnapshotPerServer AS
(
SELECT MAX(ss.DateOccured) as DateOccured, ss.ServerName
FROM		FileStats fs
INNER JOIN	WaitSnapshots ss ON fs.WaitSnapshotId = ss.WaitSnapshotId
GROUP BY	ss.ServerName
)

SELECT	ss.DateOccured, ss.ServerName,
		fs.dbname, fs.fileName,
		fs.io_stall, fs.io_stall_read_ms, fs.io_stall_write_ms, fs.num_of_reads, fs.num_of_writes, fs.size_on_disk_mb,
		 CASE WHEN fs.num_of_reads = 0  THEN 0 ELSE (fs.io_stall_read_ms / fs.num_of_reads) END as avgReadLatencyMs,
		 CASE WHEN fs.num_of_writes = 0  THEN 0 ELSE (fs.io_stall_write_ms / fs.num_of_writes) END as avgWriteLatencyMs
FROM		
cteLastFileSnapshotPerServer s
INNER JOIN	WaitSnapshots ss ON ss.ServerName = s.ServerName AND ss.DateOccured BETWEEN DateAdd(hour,-@HoursToGoBack, s.DateOccured) AND s.DateOccured
INNER JOIN	FileStats fs ON ss.WaitSnapshotId = fs.WaitSnapshotId

)

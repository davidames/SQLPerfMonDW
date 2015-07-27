
CREATE FUNCTION [dbo].[udf_Waits]
(
	@daysOld int
	
	

)
RETURNS TABLE AS RETURN
(


SELECT	s.DateOccured, wt.Name, w.SignalWaitTimeMs as SumSignalWaitTimeMs, w.WaitTimeMs as SumWaitTimeMs, w.WaitingTasksCount,
		100.0 * w.SignalWaitTimeMs / w.WaitingTasksCount  as AvgSignalWaitTimeMs,
		100.0 * w.WaitTimeMs / w.WaitingTasksCount as AvgWaitTimeMs,
		100.0 * WaitTimeMs / SUM (WaitTimeMs) OVER( PARTITION BY s.DateOccured) AS [PeriodWaitTimePercentage]

 FROM [dbo].[Waits] w
INNER JOIN WaitTypes wt on w.WaitTypeId = wt.WaitTypeId
INNER JOIN WaitSnapshots s on w.WaitSnapshotId = s.WaitSnapshotId

WHERE s.DateOccured > = DateAdd(day,-@daysOld,CAST(getdate() as Date))

)



CREATE FUNCTION tvf_WaitAnalysisGoingBackFromLatest
(
	 @HoursToGoBack int
)
RETURNS TABLE
AS
RETURN  
(

WITH cteLastWaitSnapshotPerServer AS
(
SELECT MAX(ss.DateOccured) as DateOccured, ss.ServerName
FROM		Waits w
INNER JOIN	WaitSnapshots ss ON w.WaitSnapshotId = ss.WaitSnapshotId
GROUP BY	ss.ServerName
)

SELECT	ss.DateOccured, ss.ServerName,
		w.WaitingTasksCount, w.WaitTimeMs, w.SignalWaitTimeMs,
		wt.Name,
		100.0 * WaitingTasksCount / SUM(WaitingTasksCount) OVER (PARTITION BY ss.ServerName, ss.WaitSnapshotId)  as ServerPercentWaitingTasksCount,
		100.0 * WaitTimeMs / SUM(WaitTimeMs) OVER (PARTITION BY ss.ServerName, ss.WaitSnapshotId) as ServerPercentWaitTime,		
		100.0 * SignalWaitTimeMs / SUM(SignalWaitTimeMs) OVER (PARTITION BY ss.ServerName, ss.WaitSnapshotId)  as ServerPercentSignalWaitTime
FROM		
cteLastWaitSnapshotPerServer s
INNER JOIN	WaitSnapshots ss ON ss.ServerName = s.ServerName AND ss.DateOccured BETWEEN DateAdd(hour,-@HoursToGoBack, s.DateOccured) AND s.DateOccured
INNER JOIN	Waits w ON ss.WaitSnapshotId = w.WaitSnapshotId
INNER JOIN	WaitTypes wt ON w.WaitTypeId = wt.WaitTypeId


)
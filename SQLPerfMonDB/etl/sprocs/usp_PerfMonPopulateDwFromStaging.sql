CREATE PROCEDURE [dbo].[usp_PerfMonPopulateDwFromStaging]
	
AS
	

INSERT DimMachine
(
	MachineName
)
SELECT DISTINCT s.MachineName
FROM PerfmonStaging s
LEFT JOIN DimMachine m ON s.MachineName = m.MachineName
WHERE m.MachineId IS NULL


INSERT DimCounter
(
	CounterName
)
SELECT DISTINCT s.CounterName
FROM PerfmonStaging s
LEFT JOIN DimCounter c ON s.CounterName = c.CounterName
WHERE c.CounterId IS NULL



INSERT DimCounterInstance
(
	CounterInstanceName
)
SELECT DISTINCT s.InstanceName
FROM PerfmonStaging s
LEFT JOIN DimCounterInstance c ON s.InstanceName = c.CounterInstanceName
WHERE c.CounterInstanceName IS NULL AND s.InstanceName IS NOT NULL




INSERT DimDate
(
	FullDateTime,
	DateNoTime,
	DateToTheMinute,
	DateToTheHour,
	DayOfWeek,
	Hour
)
SELECT DISTINCT s.CounterDateTime,
				CAST (s.CounterDateTime AS date),
				DateAdd(second, -DatePart(second, CounterDateTime), CounterDateTime),
				DateAdd(second, -DatePart(second, CounterDateTime), DateAdd(minute, -DatePart(minute, CounterDateTime), CounterDateTime)),
				DatePart(dw,getdate()),
				DatePart(hour, CounterDateTime)

FROM PerfmonStaging s
LEFT JOIN DimDate d ON s.CounterDateTime = d.FullDateTime
WHERE d.DateId IS NULL 


INSERT FactPerformanceCounters
(
	DateId,
	MachineId,
	CounterId,
	CounterInstanceId,
	Value,
	SourceHash
)
SELECT 	d.DateId,
		m.MachineId,
		c.CounterId,
		ci.CounterInstanceId,
		s.CounterValue,
		s.SourceHash

FROM	dbo.PerfmonStaging s
INNER JOIN DimDate d ON s.CounterDateTime = d.FullDateTime
INNER JOIN DimMachine m ON s.MachineName = m.MachineName
INNER JOIN DimCounter c ON s.CounterName = c.CounterName
INNER JOIN DimCounterInstance ci ON s.InstanceName = ci.CounterInstanceName
LEFT JOIN FactPerformanceCounters pc ON s.SourceHash = pc.SourceHash

WHERE pc.SourceHash IS NULL --Duplicate Checking


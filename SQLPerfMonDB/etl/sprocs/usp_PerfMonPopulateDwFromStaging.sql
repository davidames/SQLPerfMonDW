CREATE PROCEDURE [dbo].[usp_PerfMonPopulateDwFromStaging]
	@EtlActionExecutionId uniqueidentifier
AS
	

INSERT DimMachine
(
			MachineName
)
SELECT		DISTINCT s.MachineName
FROM		PerfmonStaging s
LEFT JOIN	DimMachine m ON s.MachineName = m.MachineName
WHERE		m.MachineId IS NULL
			AND s.EtlActionExecutionId = @EtlActionExecutionId


INSERT DimCounter
(
			CounterName
)
SELECT		DISTINCT s.CounterName
FROM		PerfmonStaging s
LEFT JOIN	DimCounter c ON s.CounterName = c.CounterName
WHERE		c.CounterId IS NULL
			AND s.EtlActionExecutionId = @EtlActionExecutionId


INSERT DimCounterType
(
			CounterTypeName
)
SELECT		DISTINCT s.ObjectName
FROM		PerfmonStaging s
LEFT JOIN	DimCounterType ct ON s.ObjectName = ct.CounterTypeName
WHERE		ct.CounterTypeId IS NULL
			AND s.EtlActionExecutionId = @EtlActionExecutionId



INSERT DimCounterInstance
(
			CounterInstanceName
)
SELECT		DISTINCT s.InstanceName
FROM		PerfmonStaging s
LEFT JOIN	DimCounterInstance c ON s.InstanceName = c.CounterInstanceName
WHERE		c.CounterInstanceName IS NULL 
			AND s.InstanceName IS NOT NULL
			AND s.EtlActionExecutionId = @EtlActionExecutionId


INSERT DimDate
(
			FullDateTime,
			DateNoTime,
			DateToTheMinute,
			DateToTheHour,
			DayOfWeek,
			Hour
)
SELECT		DISTINCT s.CounterDateTime,
			CAST (s.CounterDateTime AS date),
			DateAdd(second, -DatePart(second, CounterDateTime), CounterDateTime),
			DateAdd(second, -DatePart(second, CounterDateTime), DateAdd(minute, -DatePart(minute, CounterDateTime), CounterDateTime)),
			DatePart(dw,getdate()),
			DatePart(hour, CounterDateTime)

FROM		PerfmonStaging s
LEFT JOIN	DimDate d ON s.CounterDateTime = d.FullDateTime
WHERE		d.DateId IS NULL 
			AND s.EtlActionExecutionId = @EtlActionExecutionId


INSERT FactPerformanceCounters
(
			DateId,
			MachineId,
			CounterId,
			CounterInstanceId,
			CounterTypeId,
			Value,
			SourceHash
)

SELECT		d.DateId,
			m.MachineId,
			c.CounterId,
			ci.CounterInstanceId,
			ct.CounterTypeId,
			s.CounterValue,
			s.SourceHash

FROM		PerfmonStaging s
INNER JOIN	DimDate d ON s.CounterDateTime = d.FullDateTime
INNER JOIN	DimMachine m ON s.MachineName = m.MachineName
INNER JOIN	DimCounter c ON s.CounterName = c.CounterName
LEFT JOIN	DimCounterInstance ci ON s.InstanceName = ci.CounterInstanceName
LEFT JOIN	DimCounterType ct ON s.ObjectName = ct.CounterTypeName
LEFT JOIN	FactPerformanceCounters pc ON s.SourceHash = pc.SourceHash

WHERE		pc.SourceHash IS NULL --Duplicate Checking
AND			s.EtlActionExecutionId = @EtlActionExecutionId

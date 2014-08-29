
CREATE FUNCTION [dbo].[udf_PerfMonPerMinute]
(
	@daysOld int,
	@MachineName varchar(1024) = null,
	@CounterName varchar(1024) = null,
	@CounterInstanceName varchar(1024) = null
	

)
RETURNS TABLE AS RETURN
(
	

SELECT		d.DateToTheMinute, d.DateToTheHour, d.DateNoTime, d.DayOfWeek, d.Hour,
			m.MachineName, m.MachineEnviroment, m.MachineType,
			c.CounterName,
			ci.CounterInstanceName,
			ct.CounterTypeName,
			avg(pc.Value) as AvgValue, max(pc.value) as MaxValue, min(pc.value) as MinValue
FROM		FactPerformanceCounters pc
INNER JOIN	DimDate d ON pc.DateId = d.DateId
INNER JOIN	DimMachine m ON pc.MachineId = m.MachineId
INNER JOIN	DimCounter c ON pc.CounterId = c.CounterId
LEFT JOIN	DimCounterInstance ci ON pc.CounterInstanceId = ci.CounterInstanceId
LEFT JOIN	DimCounterType ct ON ct.CounterTypeId = pc.CounterTypeId
WHERE		d.DateNoTime > = DateAdd(WEEK,-1,CAST(getdate() as Date))
			AND
			(
				@MachineName IS NULL
				OR m.MachineName = @MachineName 
			 )
			 AND
			(
				@CounterName IS NULL
				OR c.CounterName = @CounterName 
			 )
			  AND
			(
				@CounterInstanceName IS NULL
				OR ci.CounterInstanceName = @CounterInstanceName 
			 )



GROUP BY	d.DateToTheMinute, d.DateToTheHour, d.DateNoTime, d.DayOfWeek, d.Hour,
			m.MachineName, m.MachineEnviroment, m.MachineType,
			c.CounterName,
			ci.CounterInstanceName,
			ct.CounterTypeName


)

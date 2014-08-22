CREATE FUNCTION [dbo].[udf_PerfMonPerMinute]
(
	@daysOld int
)
RETURNS TABLE AS RETURN
(
	

SELECT		d.DateToTheMinute, d.DateToTheHour, d.DateNoTime, d.DayOfWeek, d.Hour,
			m.MachineName, m.MachineEnviroment, m.MachineType,
			c.CounterName,
			ci.CounterInstanceName,
			avg(pc.Value) as AvgValue, max(pc.value) as MaxValue, min(pc.value) as MinValue
FROM		FactPerformanceCounters pc
INNER JOIN	DimDate d ON pc.DateId = d.DateId
INNER JOIN	DimMachine m ON pc.MachineId = m.MachineId
INNER JOIN	DimCounter c ON pc.CounterId = c.CounterId
INNER JOIN	DimCounterInstance ci ON pc.CounterInstanceId = ci.CounterInstanceId
WHERE		d.DateNoTime > = DateAdd(WEEK,-1,CAST(getdate() as Date))
GROUP BY	d.DateToTheMinute, d.DateToTheHour, d.DateNoTime, d.DayOfWeek, d.Hour,
			m.MachineName, m.MachineEnviroment, m.MachineType,
			c.CounterName,
			ci.CounterInstanceName


)

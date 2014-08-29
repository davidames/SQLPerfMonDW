
CREATE FUNCTION [dbo].[udf_PerfMonPerMinuteByKey]
(
	@daysOld int,
	@MachineId smallint,
	@CounterId smallint,
	@CounterInstanceId smallint = null
	

)
RETURNS TABLE AS RETURN
(
	

SELECT		d.DateToTheMinute, d.DateToTheHour, d.DateNoTime, d.DayOfWeek, d.Hour,	
			ci.CounterInstanceName,
			avg(pc.Value) as AvgValue, max(pc.value) as MaxValue, min(pc.value) as MinValue
FROM		FactPerformanceCounters pc
INNER JOIN	DimDate d ON pc.DateId = d.DateId
LEFT JOIN	DimCounterInstance ci ON pc.CounterInstanceId = ci.CounterInstanceId
WHERE		d.DateNoTime > = DateAdd(day,-@daysOld,CAST(getdate() as Date))
			AND pc.MachineId = @MachineId
			AND pc.CounterId = @CounterId
			  AND
			(
				@CounterInstanceId IS NULL
				OR pc.CounterInstanceId = @CounterInstanceId 
			 )



GROUP BY	d.DateToTheMinute, d.DateToTheHour, d.DateNoTime, d.DayOfWeek, d.Hour,
			ci.CounterInstanceName


)

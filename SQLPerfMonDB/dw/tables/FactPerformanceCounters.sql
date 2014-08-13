CREATE TABLE [dbo].[FactPerformanceCounters]
(
	[PerformanceCounterId] BIGINT NOT NULL PRIMARY KEY Identity, 
    [DateId] INT NOT NULL, 
    [MachineId] SMALLINT NOT NULL, 
    [CounterId] SMALLINT NOT NULL, 
    [CounterInstanceId] SMALLINT NOT NULL, 
    [Value] FLOAT NOT NULL
)

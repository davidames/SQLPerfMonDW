CREATE TABLE [dbo].[FactPerformanceCounters]
(
	[PerformanceCounterId] BIGINT NOT NULL PRIMARY KEY Identity, 
    [DateId] INT NOT NULL, 
    [MachineId] SMALLINT NOT NULL, 
    [CounterId] SMALLINT NOT NULL, 
    [CounterInstanceId] SMALLINT NOT NULL, 
    [Value] FLOAT NOT NULL, 
    [SourceHash] BINARY(16) NOT NULL
)
GO

CREATE INDEX IX_FactPerformanceCounters_SourceHash ON FactPerformanceCounters(SourceHash)
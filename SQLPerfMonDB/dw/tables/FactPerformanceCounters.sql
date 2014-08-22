CREATE TABLE [dbo].[FactPerformanceCounters]
(
	[PerformanceCounterId] BIGINT NOT NULL PRIMARY KEY Identity, 
    [DateId] INT NOT NULL CONSTRAINT FK_FactPerformanceCounters_DateId FOREIGN KEY REFERENCES DimDate(DateId), 
    [MachineId] SMALLINT NOT NULL CONSTRAINT FK_FactPerformanceCounters_MachineId FOREIGN KEY REFERENCES DimMachine(MachineId),
    [CounterId] SMALLINT NOT NULL CONSTRAINT FK_FactPerformanceCounters_CounterId FOREIGN KEY REFERENCES DimCounter(CounterId), 
    [CounterInstanceId] SMALLINT NULL CONSTRAINT FK_FactPerformanceCounters_CounterInstanceId FOREIGN KEY REFERENCES DimCounterInstance(CounterInstanceId),
    [Value] FLOAT NOT NULL, 
    [SourceHash] BINARY(16) NOT NULL, 
    [CounterTypeId] SMALLINT NULL CONSTRAINT FK_FactPerformanceCounters_CounterTypeId FOREIGN KEY REFERENCES DimCounterType(CounterTypeId)
)
GO

CREATE INDEX IX_FactPerformanceCounters_SourceHash ON FactPerformanceCounters(SourceHash)


GO

CREATE NONCLUSTERED INDEX IX_FactPerformanceCounters_DateId_1
ON [dbo].[FactPerformanceCounters] ([DateId])

INCLUDE ([MachineId],[CounterId],[CounterInstanceId],[Value])


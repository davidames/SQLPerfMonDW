
CREATE TABLE [dbo].QueryPerformance(
	QueryPerformanceID BigInt identity(1,1) NOT NULL CONSTRAINT PK_QueryPerformance PRIMARY KEY,
	CollectionSetID uniqueIdentifier CONSTRAINT FK_QueryPerformance_CollectionSetID FOREIGN KEY REFERENCES Collection ([CollectionId]),
	[ExecutionCount] [bigint] NOT NULL,
	[TotalWorkerTime] [bigint] NOT NULL,
	[TotaElapsedTime] [bigint] NOT NULL,
	[TotalLogicalWrites] [bigint] NOT NULL,
	[TotalLogicalReads] [bigint] NOT NULL,
	[TotalPhysicalReads] [bigint] NOT NULL,
	[ExampleSqlHandle] [varbinary](64) NOT NULL,
	[ExamplePlanHandle] [varbinary](64) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[QueryTextFingerPrint] [binary](8) NOT NULL,
	[QueryPlanFingerPrint] [binary](8) NOT NULL,
	[StatementStartOffset] [int] NOT NULL,
	[StatementEndOffset] [int] NOT NULL
) ON [PRIMARY]

GO


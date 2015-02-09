CREATE TABLE [dbo].[FactQueryPerformance]
(
	[QueryPerformanceId] BigInt identity(1,1) NOT NULL CONSTRAINT PK_FactQueryPerformance PRIMARY KEY,
	CollectionSetId int CONSTRAINT FK_FactQueryPerformance_CollectionSetId FOREIGN KEY REFERENCES DimCollectionSet ([CollectionSetId]) NOT NULL,
	CollectionId int CONSTRAINT FK_FactQueryPerformance_CollectionId FOREIGN KEY REFERENCES DimCollection ([CollectionId]) NOT NULL,
	MachineId smallint CONSTRAINT FK_FactQueryPerformance_MachineId FOREIGN KEY REFERENCES DimMachine (MachineId) NOT NULL,
	StatementId int CONSTRAINT FK_FactQueryPerformance_StatementId FOREIGN KEY REFERENCES DimStatement (StatementId) NOT NULL,
	QueryTextId int CONSTRAINT FK_FactQueryPerformance_QueryTextId FOREIGN KEY REFERENCES DimQueryText (QueryTextId) NOT NULL,
	QueryPlanId int CONSTRAINT FK_FactQueryPerformance_QueryPlanId FOREIGN KEY REFERENCES DimQueryPlan (QueryPlanId) NOT NULL,
	DatabaseId smallint CONSTRAINT FK_FactQueryPerformance_DatabaseId FOREIGN KEY REFERENCES DimDatabase (DatabaseId) NOT NULL,
	[ExecutionCount] [bigint] NOT NULL,
	[TotalWorkerTimeMS] [bigint] NOT NULL,
	[TotaElapsedTimeMS] [bigint] NOT NULL,
	[TotalLogicalWrites] [bigint] NOT NULL,
	[TotalLogicalReads] [bigint] NOT NULL,
	[TotalPhysicalReads] [bigint] NOT NULL
	
)

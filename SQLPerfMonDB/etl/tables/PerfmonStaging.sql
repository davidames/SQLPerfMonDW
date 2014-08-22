CREATE TABLE [dbo].[PerfmonStaging]
(
	Id bigint identity,
	MachineName varchar(1024) NOT NULL,		
	CounterName varchar(1024) NOT NULL,		
	InstanceName varchar(1024) NULL,	
	CounterValue FLOAT (53) NOT NULL,	
	CounterDateTime DATETIME NOT NULL, 
    [SourceHash] BINARY(16) NOT NULL,
	[ObjectName] VARCHAR(1024) NULL, 
    CONSTRAINT PK_PerfMonStaging PRIMARY KEY NONCLUSTERED (Id)	
)

GO

CREATE CLUSTERED INDEX  CIX_PerfmonStaging_CounterDateTime ON PerfmonStaging(CounterDateTime)



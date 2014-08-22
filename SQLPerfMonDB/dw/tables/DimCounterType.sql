CREATE TABLE [dbo].[DimCounterType]
(
	[CounterTypeId] SMALLINT NOT NULL identity, 
    [CounterTypeName] VARCHAR(50) NOT NULL
	CONSTRAINT PK_DimCounterTypes PRIMARY KEY (CountertypeId)
)

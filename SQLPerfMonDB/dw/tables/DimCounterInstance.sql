CREATE TABLE [dbo].[DimCounterInstance]
(
	[CounterInstanceId] SMALLINT NOT NULL Identity, 
    [CounterInstanceName] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_CounterInstance PRIMARY KEY (CounterInstanceId)
)

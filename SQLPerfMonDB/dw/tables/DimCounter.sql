CREATE TABLE [dbo].[DimCounter]
(
	[CounterId] SMALLINT NOT NULL Identity, 
    [CounterName] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_DimCouner PRIMARY KEY (CounterId)
)

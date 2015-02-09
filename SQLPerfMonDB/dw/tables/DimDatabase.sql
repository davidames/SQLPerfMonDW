CREATE TABLE [dbo].[DimDatabase]
(
	[DatabaseId] SMALLINT NOT NULL Identity , 
    [DatabaseName] VARCHAR(120) NOT NULL,
	CONSTRAINT PK_DimDatabase PRIMARY KEY (DatabaseId) 
)

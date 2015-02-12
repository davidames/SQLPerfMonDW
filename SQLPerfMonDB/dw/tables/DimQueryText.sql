CREATE TABLE [dbo].[DimQueryText]
(
QueryTextId int identity CONSTRAINT PK_DimQueryText PRIMARY KEY CLUSTERED,
QueryTextFingerPrint binary(8),
QueryText varchar(max) NOT NULL,
SourceDbName sysname NULL,
CreatedOn DateTimeOffset NOT NULL 


)
GO
CREATE UNIQUE INDEX UIX_DimQueryText_QueryTextFingerPrint ON DimQueryText(QueryTextFingerPrint)
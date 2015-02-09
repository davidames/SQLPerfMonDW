CREATE TABLE [dbo].[DimStatement]
(
	StatementId INT NOT NULL CONSTRAINT PK_DimStatement PRIMARY KEY,
	StartOffset int NOT NULL,
	EndOffset int NOT NULL,
	QueryTextId int NOT NULL CONSTRAINT FK_DimStatement_QueryTextId FOREIGN KEY REFERENCES DimQueryText(QueryTextId)
)

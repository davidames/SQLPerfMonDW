CREATE TABLE [dbo].[DimCollectionSet]
(
	CollectionSetId INT identity NOT NULL CONSTRAINT PK_DimCollectionSet PRIMARY KEY, 
    DateId INT CONSTRAINT FK_DimCollectionSet_DateId FOREIGN KEY REFERENCES DimDate(DateId),
	DayIndex INT NULL /* This is the nth collection for the day*/
)

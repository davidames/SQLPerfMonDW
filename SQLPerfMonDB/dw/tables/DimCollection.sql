CREATE TABLE [dbo].[DimCollection]
(
	[CollectionId] INT identity NOT NULL CONSTRAINT PK_DimCollection PRIMARY KEY, 
    [MachineId] SMALLINT NOT NULL CONSTRAINT FK_DimCollection_MachineId FOREIGN KEY REFERENCES DimMachine(MachineId), 
    [CollectionSetId] INT NULL CONSTRAINT FK_DimCollection_CollectionSetId FOREIGN KEY REFERENCES DimCollectionSet(CollectionSetId), 
    [OriginalCollectionId] UNIQUEIDENTIFIER NOT NULL, 
    
)

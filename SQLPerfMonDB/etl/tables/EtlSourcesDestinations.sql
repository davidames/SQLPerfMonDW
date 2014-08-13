CREATE TABLE [dbo].[EtlSourcesDestinations]
(
	[EtlSourceDestinationId] INT NOT NULL PRIMARY KEY, 
    [SourceServer] varchar(1024) NULL, 
    [DestServer] varchar(1024) NULL
)

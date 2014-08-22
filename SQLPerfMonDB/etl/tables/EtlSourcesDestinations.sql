CREATE TABLE [dbo].[EtlSourcesDestinations]
(
	[EtlSourceDestinationId] INT NOT NULL identity PRIMARY KEY, 
    [SourceServer] varchar(1024) NULL, 
    [DestServer] varchar(1024) NULL, 
    [DestDatabase] VARCHAR(1024) NULL, 
    [SourceDatabase] VARCHAR(1024) NULL, 
    [IsActive] BIT NOT NULL CONSTRAINT DF_EtlSourcesDestinations_IsActive DEFAULT(0)
)

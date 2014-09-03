CREATE TABLE [dbo].[EtlActions]
(
	[EtlActionId] INT NOT NULL identity, 
    [SourceServer] varchar(1024) NULL, 
    [DestServer] varchar(1024) NULL, 
    [DestDatabase] VARCHAR(1024) NULL, 
    [SourceDatabase] VARCHAR(1024) NULL, 
    [IsActive] BIT NOT NULL CONSTRAINT DF_EtlSourcesDestinations_IsActive DEFAULT(0),
	CONSTRAINT PK_EtlSourcesDestinations PRIMARY KEY (EtlActionId)
)

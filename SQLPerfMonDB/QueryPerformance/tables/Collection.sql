CREATE TABLE [dbo].[Collection]
(
	[CollectionId] uniqueidentifier NOT NULL  CONSTRAINT PK_Collection PRIMARY KEY,
	StartedOn DateTimeOffset CONSTRAINT  DF_Collection_StartedOn DEFAULT (sysDateTimeOffset()) NOT NULL,
	CompletedOn  DateTimeOffset NULL, 
    [MachineName] VARCHAR(120) NULL CONSTRAINT CF_Collection_MachineName DEFAULT (@@ServerName)
)

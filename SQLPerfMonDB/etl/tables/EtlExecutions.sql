CREATE TABLE [dbo].[EtlExecutions]
(
	[EtlExecutionId] uniqueidentifier NOT NULL, 
    [StartedOn] DATETIMEOFFSET NOT NULL, 
    [CompletedOn] DATETIMEOFFSET NULL,
	CONSTRAINT PK_EtlExecutions PRIMARY KEY (EtlExecutionId)
)

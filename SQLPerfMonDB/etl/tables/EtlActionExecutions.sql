CREATE TABLE [dbo].[EtlActionExecutions]
(
	[EtlActionExecutionId] uniqueidentifier NOT NULL CONSTRAINT DF_EtlActionExecutions_EtlActionExecutionId DEFAULT (newid()),
	[EtlActionId] INT NOT NULL CONSTRAINT FK_EtlActionExecutions_EtlActionId FOREIGN KEY REFERENCES EtlActions(EtlActionId), 
    [EtlExecutionId] uniqueidentifier NOT NULL CONSTRAINT FK_EtlActionExecutions_EtlExecutionId FOREIGN KEY REFERENCES EtlExecutions(EtlExecutionId), 
    [StartedOn] DATETIMEOFFSET NOT NULL, 
    [CompletedOn] DATETIMEOFFSET NULL, 
    [ErrorDetails] VARCHAR(MAX) NULL,
	CONSTRAINT PK_EtlActionExecutions PRIMARY KEY (EtlActionExecutionId)
  
)

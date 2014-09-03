CREATE PROCEDURE [dbo].[usp_EtlAllSources]
	
AS
	
DECLARE @SourceServerName sysname,
		@SourceDatabaseName sysname ,
		@DestServerName  sysname ,
		@DestDatabaseName sysname,
		@EtlExecutionId uniqueidentifier = newid(),
		@EtlActionExecutionId uniqueidentifier,
		@EtlActionid int

		
INSERT dbo.EtlExecutions
(
	EtlExecutionId,
	StartedOn
)

VALUES
(
	@EtlExecutionId,
	SYSDATETIMEOFFSET()
)

DECLARE c CURSOR FOR

SELECT SourceServer, SourceDatabase, DestServer,  DestDatabase, EtlActionId
FROM EtlActions


OPEN c
FETCH c INTO @SourceServerName,@SourceDatabaseName,  @DestServerName,  @DestDatabaseName, @EtlActionId
WHILE @@FETCH_STATUS = 0
BEGIN

	
	DECLARE @Msg varchar(1024) = 'Perfmon - Starting ETL from: ' + @SourceServerName + ' to ' + @DestServerName 
	RAISERROR (@Msg, 0, 1) WITH NOWAIT
	
	SET @EtlActionExecutionId = newid()


	INSERT EtlActionExecutions
	(
		EtlActionExecutionId,
		EtlActionId,
		EtlExecutionId,
		StartedOn
	)
	VALUES
	(
		@EtlActionExecutionId,
		@EtlActionid,
		@EtlExecutionId,
		SYSDATETIMEOFFSET()

	)
	EXEC usp_EtlSingleSource @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName, @EtlActionExecutionId

	UPDATE EtlActionExecutions
	SET CompletedOn = SYSDATETIMEOFFSET()
	WHERE EtlActionExecutionId = @EtlActionExecutionId

	RAISERROR ('------------------------------------------------------------------------', 0, 1) WITH NOWAIT
	

FETCH c INTO @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName, @EtlActionId


END

UPDATE EtlExecutions
SET CompletedOn = SYSDATETIMEOFFSET()
WHERE EtlExecutionId = @EtlActionExecutionId




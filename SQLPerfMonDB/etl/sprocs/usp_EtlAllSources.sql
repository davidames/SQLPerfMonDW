CREATE PROCEDURE [dbo].[usp_EtlAllSources]
	
AS
	
	
DECLARE @SourceServerName sysname,
		@SourceDatabaseName sysname,
		@DestServerName  sysname,
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
WHERE IsActive = 1

OPEN c
FETCH c INTO @SourceServerName,@SourceDatabaseName,  @DestServerName,  @DestDatabaseName, @EtlActionId
WHILE @@FETCH_STATUS = 0
BEGIN

	
	DECLARE @Msg varchar(1024) = 'Perfmon - Starting ETL from: ' + @SourceServerName + ' to ' + @DestServerName 
	EXEC usp_LogMessage @Msg
	
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

	EXEC usp_LogMessage 'Calling usp_EtlSingleSource'
	BEGIN TRY
		EXEC usp_EtlSingleSource @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName, @EtlActionExecutionId
	END TRY

	BEGIN CATCH 
		SET @Msg = 'Error: ' + ERROR_MESSAGE() + ' Severity: ' + CAST(ERROR_SEVERITY() as varchar(10)) + ' State: ' + CAST(ERROR_STATE() as varchar(10)) + ' Line:' + CAST(ERROR_LINE() as varchar(10)) + ' ' + ISNULL(ERROR_PROCEDURE(),'-')
		UPDATE EtlActionExecutions
		SET ErrorDetails = @Msg
		WHERE EtlActionExecutionId = @EtlActionExecutionId

		EXEC usp_LogMessage @Msg
	END CATCH

	UPDATE EtlActionExecutions
	SET CompletedOn = SYSDATETIMEOFFSET()
	WHERE EtlActionExecutionId = @EtlActionExecutionId

	EXEC usp_LogMessage '------------------------------------------------------------------------'
	

	FETCH c INTO @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName, @EtlActionId


END

UPDATE	EtlExecutions
SET		CompletedOn = SYSDATETIMEOFFSET()
WHERE	EtlExecutionId = @EtlActionExecutionId




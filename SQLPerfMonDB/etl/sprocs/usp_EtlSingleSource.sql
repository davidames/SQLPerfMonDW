CREATE PROCEDURE [dbo].[usp_EtlSingleSource]
		
		@SourceServerName sysname,
		@SourceDatabaseName sysname ,
		@DestServerName  sysname ,
		@DestDatabaseName sysname,
		@EtlActionExecutionId uniqueidentifier

AS
	


DECLARE @Sql nvarchar(max),
		@DestServerPath varchar(1024) = '',
		@SourceServerPath varchar(1024) = '',
		@Message varchar(max)

If (@SourceServerName IS NOT NULL)
	SET @SourceServerPath = @SourceServerPath + @SourceServerName + '.'

If (@SourceDatabaseName IS NOT NULL)
	SET @SourceServerPath = @SourceServerPath + @SourceDatabaseName + '.'

If (@DestServerName IS NOT NULL)
	SET @DestServerPath = @DestServerPath + @DestServerName + '.'

If (@DestDatabaseName IS NOT NULL)
	SET @DestServerPath = @DestServerPath + @DestDatabaseName + '.'

SET @Message = 'Source Server Path: ' + @SourceServerPath
EXEC usp_LogMessage @Message

SET @Message = 'Dest Server Path: ' + @DestServerPath
EXEC usp_LogMessage @Message



EXEC usp_PerfMonEtlPopulateStaging @SourceServerName, @SourceDatabaseName,  @DestServerName, @DestDatabaseName, @EtlActionExecutionId

SET @Sql =  @DestServerPath+'dbo.usp_PerfMonPopulateDwFromStaging  ''' + CAST(@EtlActionExecutionId as varchar(36))  + ''''

EXEC usp_LogDynamicSql 'Populating DW tables from Staging Table', @Sql

EXEC sp_ExecuteSQL @Sql


SET @Sql =  + @DestServerPath + 'dbo.usp_PerfMonEtlCleanStaging ''' + CAST(@EtlActionExecutionId as varchar(36))  + ''''

EXEC usp_LogDynamicSql 'Cleaning Staging Table', @Sql

EXEC sp_ExecuteSQL @Sql







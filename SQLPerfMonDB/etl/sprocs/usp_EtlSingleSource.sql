CREATE PROCEDURE [dbo].[usp_EtlSingleSource]
		
		@SourceServerName sysname,
		@SourceDatabaseName sysname ,
		@DestServerName  sysname ,
		@DestDatabaseName sysname,
		@EtlActionExecutionId uniqueidentifier

AS
	

DECLARE @Sql nvarchar(max),
		@DestServerPath varchar(1024) = @DestServerName + '.' + @DestDatabaseName + '.',
		@SourceServerPath varchar(1024) = @SourceServerName + '.' + @SourceDatabaseName + '.'

RAISERROR ('Perfmon - Cleaning Staging Table', 0, 1) WITH NOWAIT

SET @Sql =  + @DestServerPath + 'dbo.usp_PerfMonEtlCleanStaging'

EXEC @Sql



RAISERROR ('Perfmon - Populating Staging Table', 0, 1) WITH NOWAIT


exec	usp_PerfMonEtlPopulateStaging @SourceServerName, @SourceDatabaseName,  @DestServerName, @DestDatabaseName


RAISERROR ('Perfmon - Populating Dw from Staging', 0, 1) WITH NOWAIT

SET @Sql =  @DestServerPath+'dbo.usp_PerfMonPopulateDwFromStaging'
	
EXEC sp_ExecuteSQL @Sql







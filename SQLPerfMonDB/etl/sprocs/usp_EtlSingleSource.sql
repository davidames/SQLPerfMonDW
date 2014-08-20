CREATE PROCEDURE [dbo].[usp_EtlSingleSource]
	 @SourceServerPath sysname,
	 @DestServerPath sysname
AS
	

DECLARE @Sql nvarchar(max)

RAISERROR ('Perfmon - Cleaning Staging Table', 0, 1) WITH NOWAIT

SET @Sql =  + @DestServerPath + 'dbo.usp_PerfMonEtlCleanStaging'

EXEC @Sql



RAISERROR ('Perfmon - Populating Staging Table', 0, 1) WITH NOWAIT


exec	usp_PerfMonEtlPopulateStaging @SourceServerPath, @DestServerPath


RAISERROR ('Perfmon - Populating Dw from Staging', 0, 1) WITH NOWAIT

SET @Sql =  @SourceServerPath+'dbo.usp_PerfMonPopulateDwFromStaging'
	
EXEC sp_ExecuteSQL @Sql




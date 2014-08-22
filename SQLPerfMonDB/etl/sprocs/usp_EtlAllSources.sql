CREATE PROCEDURE [dbo].[usp_EtlAllSources]
	
AS
	
DECLARE @SourceServerName sysname,
		@SourceDatabaseName sysname ,
		@DestServerName  sysname ,
		@DestDatabaseName sysname

DECLARE c CURSOR FOR

SELECT SourceServer, SourceDatabase, DestServer,  DestDatabase
FROM EtlSourcesDestinations


OPEN c
FETCH c INTO @SourceServerName,@SourceDatabaseName,  @DestServerName,  @DestDatabaseName
WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE @Msg varchar(1024) = 'Perfmon - Starting ETL from: ' + @SourceServerName + ' to ' + @DestServerName 
	RAISERROR (@Msg, 0, 1) WITH NOWAIT
	EXEC usp_EtlSingleSource @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName
	RAISERROR ('------------------------------------------------------------------------', 0, 1) WITH NOWAIT
	

FETCH c INTO @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName


END



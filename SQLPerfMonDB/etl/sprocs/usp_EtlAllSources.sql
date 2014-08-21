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
	
	EXEC usp_EtlSingleSource @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName


FETCH c INTO @SourceServerName, @SourceDatabaseName, @DestServerName, @DestDatabaseName


END



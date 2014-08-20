CREATE PROCEDURE [dbo].[usp_EtlAllSources]
	
AS
	
DECLARE @SourceServer sysname, 
		@DestServer sysname

DECLARE c CURSOR FOR

SELECT SourceServer, DestServer
FROM EtlSourcesDestinations


OPEN c
FETCH c INTO @SourceServer, @DestServer
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SourceServer = ISNULL(@SourceServer + '.', '')
	SET @DestServer = ISNULL(@DestServer + '.', '')

	exec usp_EtlSingleSource @SourceServer, @DestServer


FETCH c INTO @SourceServer, @DestServer


END



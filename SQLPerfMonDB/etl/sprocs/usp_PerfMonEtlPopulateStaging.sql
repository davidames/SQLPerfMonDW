
CREATE PROC [dbo].usp_PerfMonEtlPopulateStaging

		
		
		@SourceServerName sysname,
		@SourceDatabaseName sysname ,
		@DestServerName  sysname ,
		@DestDatabaseName sysname


		AS 
		
DECLARE @EtlStartingPoints TABLE (Guid uniqueidentifier, MaxCounterId int, MaxRecordIndex int)
DECLARE @Sql nvarchar(max),
		@Guid uniqueidentifier,
		@MaxCounterId int,
		@MaxRecordIndex int

SET @Sql = '
SELECT	Guid, MaxCounterId, MaxRecordIndex
FROM	OPENQUERY('+@SourceServerName+', ''SELECT * FROM '+ @SourceDatabaseName +'.dbo.PerfMonEtlStartingPoints() '')
'

select @Sql

RAISERROR ('Calculating Starting Points', 0, 1) WITH NOWAIT

	
INSERT INTO  @EtlStartingPoints
(
		Guid,
		MaxCounterId,
		MaxRecordIndex
)



EXEC sp_ExecuteSQL @Sql


DECLARE c CURSOR FOR
SELECT		Guid, MaxCounterId, MaxRecordIndex
FROM		@EtlStartingPoints

OPEN c
FETCH c INTO @Guid, @MaxCounterId, @MaxRecordIndex
WHILE @@FETCH_STATUS = 0
BEGIN
	
	RAISERROR ('Inserting into staging table', 0, 1) WITH NOWAIT

		SET @Sql = 'INSERT ' + @DestServerName + '.' + @DestDatabaseName + '.dbo.PerfMonStaging
	(
		MachineName,		
		CounterName,		
		InstanceName,	
		CounterValue,	
		CounterDateTime,
		SourceHash	
	)

	SELECT 
		MachineName,		
		CounterName,		
		InstanceName,	
		CounterValue,	
		(CONVERT([datetime],left([CounterDateTime],(19)),(120))),
		SourceHash	
	
	FROM OPENQUERY('+@SourceServerName+', ''SELECT * FROM ' + @SourceDatabaseName + '.dbo.PerfMonRecordsToEtl('''''+ CAST(@Guid as nvarchar(36))+''''', '+CAST(@MaxCounterId as nvarchar(10)) +', '+CAST(@MaxRecordIndex as nvarchar(10))+')'')
	'



EXEC sp_ExecuteSQL @Sql


RAISERROR ('Perfmon - Clearing Source Data', 0, 1) WITH NOWAIT

SET @Sql =  @SourceServerName + '.' + @SourceDatabaseName+'.dbo.usp_ClearSourceData ''' + CAST(@Guid as nvarchar(36))+''', ' + CAST(@MaxCounterId as nvarchar(20)) + ', '+ CAST(@MaxRecordIndex as nvarchar(20))


EXEC sp_ExecuteSQL @Sql



FETCH c INTO @Guid, @MaxCounterId, @MaxRecordIndex

END 
CLOSE c
DEALLOCATE c

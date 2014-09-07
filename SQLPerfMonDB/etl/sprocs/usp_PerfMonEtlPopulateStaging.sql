
CREATE PROC [dbo].usp_PerfMonEtlPopulateStaging
		
		@SourceServerName sysname,
		@SourceDatabaseName sysname ,
		@DestServerName  sysname ,
		@DestDatabaseName sysname,
		@EtlActionExecutionId uniqueidentifier

		AS 
		
DECLARE @EtlStartingPoints TABLE (Guid uniqueidentifier, MaxCounterId int, MaxRecordIndex int)
DECLARE @Sql nvarchar(max),
		@Guid uniqueidentifier,
		@MaxCounterId int,
		@MaxRecordIndex int

SET @Sql = '
SELECT	Guid, MaxCounterId, MaxRecordIndex
'
IF @SourceServerName IS NOT NULL
	SET @Sql = @Sql + 'FROM	OPENQUERY('+@SourceServerName+', ''SELECT * FROM '+ @SourceDatabaseName +'.dbo.PerfMonEtlStartingPoints() '')'
ELSE IF @SourceDatabaseName IS NOT NULL
	SET @Sql = @Sql +  'FROM '+ @SourceDatabaseName +'.dbo.PerfMonEtlStartingPoints() '
ELSE
	SET @Sql = @Sql +  'FROM dbo.PerfMonEtlStartingPoints() '
	

EXEC usp_LogDynamicSql 'Calculation of SQL Starting  Points',  @sql
RAISERROR ('Calculating Starting Points', 0, 1) WITH NOWAIT
	
INSERT INTO  @EtlStartingPoints
(
		Guid,
		MaxCounterId,
		MaxRecordIndex
)

EXEC sp_ExecuteSQL @Sql


DECLARE c	CURSOR FOR
SELECT		Guid, MaxCounterId, MaxRecordIndex
FROM		@EtlStartingPoints

OPEN c
FETCH c INTO @Guid, @MaxCounterId, @MaxRecordIndex
WHILE @@FETCH_STATUS = 0
BEGIN
	
	RAISERROR ('Inserting into staging table', 0, 1) WITH NOWAIT

	IF @DestServerName IS NOT NULL
		SET @Sql = 'INSERT ' + @DestServerName + '.' + @DestDatabaseName + '.dbo.PerfMonStaging'
	ELSE IF @DestDatabaseName IS NOT NULL
		SET @Sql = 'INSERT ' + @DestDatabaseName + '.dbo.PerfMonStaging'
	ELSE
		SET @Sql = 'INSERT PerfMonStaging'

		SET @Sql = @Sql + '
		

	(
		MachineName,		
		CounterName,		
		InstanceName,	
		ObjectName,
		CounterValue,	
		CounterDateTime,
		SourceHash,
		EtlActionExecutionId
	)

	SELECT 
		MachineName,		
		CounterName,		
		InstanceName,	
		ObjectName,
		CounterValue,	
		(CONVERT([datetime],left([CounterDateTime],(19)),(120))),
		SourceHash,
		'''+CAST(@EtlActionExecutionId as varchar(36))+'''
	'

	IF @SourceServerName IS NOT NULL
		SET @Sql = @Sql + 'FROM OPENQUERY('+@SourceServerName+', ''SELECT * FROM ' + @SourceDatabaseName + '.dbo.PerfMonRecordsToEtl('''''+ CAST(@Guid as nvarchar(36))+''''', '+CAST(@MaxCounterId as nvarchar(10)) +', '+CAST(@MaxRecordIndex as nvarchar(10))+')'')'
	ELSE IF @SourceDatabaseName IS NOT NULL
		SET @Sql = @Sql +  'FROM ' + @SourceDatabaseName + '.dbo.PerfMonRecordsToEtl('''+ CAST(@Guid as nvarchar(36))+''', '+CAST(@MaxCounterId as nvarchar(10)) +', '+CAST(@MaxRecordIndex as nvarchar(10))+')'
	ELSE
		SET @Sql = @Sql +  'FROM PerfMonRecordsToEtl('''+ CAST(@Guid as nvarchar(36))+''', '+CAST(@MaxCounterId as nvarchar(10)) +', '+CAST(@MaxRecordIndex as nvarchar(10))+')'
	
	EXEC usp_LogDynamicSql 'Insert into Staging from Source data',  @sql

	EXEC sp_ExecuteSQL @Sql

	RAISERROR ('Perfmon - Clearing Source Data', 0, 1) WITH NOWAIT

	IF @SourceServerName IS NOT NULL
		SET @Sql =  @SourceServerName + '.' + @SourceDatabaseName+'.dbo.usp_ClearSourceData ''' + CAST(@Guid as nvarchar(36))+''', ' + CAST(@MaxCounterId as nvarchar(20)) + ', '+ CAST(@MaxRecordIndex as nvarchar(20))
	ELSE IF @SourceDatabaseName IS NOT NULL
		SET @Sql =  @SourceDatabaseName+'.dbo.usp_ClearSourceData ''' + CAST(@Guid as nvarchar(36))+''', ' + CAST(@MaxCounterId as nvarchar(20)) + ', '+ CAST(@MaxRecordIndex as nvarchar(20))
	ELSE
		SET @Sql =  'usp_ClearSourceData ''' + CAST(@Guid as nvarchar(36))+''', ' + CAST(@MaxCounterId as nvarchar(20)) + ', '+ CAST(@MaxRecordIndex as nvarchar(20))

	EXEC usp_LogDynamicSql 'Clearing Source Data',  @sql

	EXEC sp_ExecuteSQL @Sql


	FETCH c INTO @Guid, @MaxCounterId, @MaxRecordIndex

END 
CLOSE c
DEALLOCATE c

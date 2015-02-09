CREATE PROCEDURE [dbo].[usp_CaptureQueryPerformance]
	@TopRowsPerCategory int = 20,
		@MaxAgeDays int = 7
AS
	
DECLARE @CollectionId uniqueidentifier = newid()

INSERT Collection
(
	CollectionId,
	StartedOn
)

SELECT
	@CollectionId,
	SYSDATETIMEOFFSET()


;WITH cteData 
AS 
(
SELECT 
		DB_NAME (CONVERT (int, [database_id].value)) as databaseName,
		row_number() OVER ( PARTITION BY (DB_NAME (CONVERT (int, [database_id].value)) )  ORDER BY SUM(qs.execution_count) DESC ) as SortCountExecutions,
		row_number() OVER ( PARTITION BY (DB_NAME (CONVERT (int, [database_id].value)) )  ORDER BY SUM(qs.total_logical_reads) DESC ) as SortLogicalReads,
		row_number() OVER ( PARTITION BY (DB_NAME (CONVERT (int, [database_id].value)) )  ORDER BY SUM(qs.total_physical_reads) DESC ) as SortPhysicalReads,
		row_number() OVER ( PARTITION BY (DB_NAME (CONVERT (int, [database_id].value)) )  ORDER BY SUM(qs.total_worker_time) DESC ) as SortWorkerTime,
		row_number() OVER ( PARTITION BY (DB_NAME (CONVERT (int, [database_id].value)) )  ORDER BY SUM(qs.total_elapsed_time) DESC ) as SortElapsedTime,		
		sum(qs.execution_count) as executionCount, 
		sum(qs.total_worker_time) as totalWorkerTime, 
		sum(qs.total_elapsed_time) as totaElapsedTime, 
		sum(qs.total_logical_writes) as totalLogicalWrites, 
		sum(qs.total_logical_reads) as totalLogicalReads, 
		sum(qs.total_physical_reads) as totalPhysicalReads,	
	    MAX(qs.plan_handle) as examplePlanHandle, MAX(qs.sql_handle) as exampleSqlHandle, 
		qs.query_plan_hash as QueryPlanFingerPrint, 
		qs.query_hash as QueryTextFingerPrint,
		qs.statement_start_offset as statementStartOffset,
		qs.statement_end_offset as statementEndOffset
	
FROM   sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_plan_attributes (qs.plan_handle) AS [database_id]

 WHERE
         [database_id].attribute = 'dbid'
         AND qs.last_execution_time > dateAdd(day, -@MaxAgeDays, getdate())	
		 AND (CONVERT (int, [database_id].value))> 4
GROUP BY  qs.query_plan_hash, qs.query_hash,
          DB_NAME (CONVERT (int, [database_id].value)) ,
		  qs.statement_start_offset, qs.statement_end_offset
         
         
         )
		 
		 
INSERT QueryPerformance
(
	
	CollectionSetID,
	ExecutionCount,
	totalWorkerTime,
	totaElapsedTime,
	totalLogicalWrites,
	totalLogicalReads,
	totalPhysicalReads,
	exampleSqlHandle,
	examplePlanHandle,
	databaseName,
	QueryTextFingerPrint,
	QueryPlanFingerPrint,
	statementStartOffset,
	statementEndOffset
)		

SELECT 
		@CollectionID,
		executionCount, 
		totalWorkerTime, 
		 totaElapsedTime, 
		 totalLogicalWrites, 
		 totalLogicalReads, 
		totalPhysicalReads,
	    exampleSqlHandle, 
	    examplePlanHandle,
	    databaseName,
	    QueryTextFingerPrint,
	    QueryPlanFingerPrint,
		statementStartOffset,
		statementEndOffset
	
	

FROM cteData
WHERE	(SortCountExecutions <= @TopRowsPerCategory OR
		SortLogicalReads  <= @TopRowsPerCategory OR
		SortPhysicalReads  <= @TopRowsPerCategory OR
		SortWorkerTime  <= @TopRowsPerCategory OR
		SortElapsedTime  <= @TopRowsPerCategory )
		AND databaseName IS NOT NULL



		
/* 
	Create SQL Texts Objects
*/	
	;WITH cteUniqueMissing AS 
	(
	SELECT DISTINCT pd.QueryTextFingerPrint
	FROM QueryPerformance pd
	LEFT JOIN QueryTexts q ON pd.QueryTextFingerPrint = q.QueryTextFingerPrint
	WHERE 
	pd.CollectionSetID = @CollectionID
	AND
	q.QueryTextFingerPrint IS NULL
	)


INSERT QueryTexts
(
	QueryTextFingerPrint,
	QueryText ,
	SourceDbName 
)
	SELECT um.QueryTextFingerPrint, qt.text,  isnull(db_name(qt.dbid), sqlHandle.databasename)
	FROM cteUniqueMissing um
	CROSS APPLY
	(
		SELECT TOP 1 pd.exampleSqlHandle, pd.databaseName
		FROM QueryPerformance pd
		WHERE	pd.QueryTextFingerPrint = um.QueryTextFingerPrint
		AND pd.CollectionSetID = @CollectionID	
		AND pd.examplePlanHandle IS NOT NULL
	) as sqlHandle
	CROSS APPLY sys.dm_exec_sql_text(sqlHandle.exampleSqlHandle) AS qt 



	/*
	Create QueryPlan Objects
	*/
	;WITH cteUniqueMissing AS 
	(
	SELECT DISTINCT pd.QueryPlanFingerPrint
	FROM QueryPerformance pd
	LEFT JOIN QueryPlans q ON pd.QueryPlanFingerPrint = q.QueryPlanFingerPrint
	WHERE 
	pd.CollectionSetID = @CollectionID
	AND q.QueryPlanFingerPrint IS NULL
	)

INSERT QueryPlans
(
	QueryPlanFingerPrint,
	QueryPlan ,
	SourceDbName 
)
	SELECT um.QueryPlanFingerPrint, qp.query_plan, isnull(db_name(qp.dbid), sqlHandle.databasename)
	FROM cteUniqueMissing um
	CROSS APPLY
	(
		SELECT TOP 1 pd.examplePlanHandle, pd.databaseName
		FROM QueryPerformance pd
		WHERE	
		pd.CollectionSetID = @CollectionID
		AND
		pd.QueryPlanFingerPrint = um.QueryPlanFingerPrint	
		AND pd.examplePlanHandle IS NOT NULL
	
	) as sqlHandle
	CROSS APPLY sys.dm_exec_query_plan(sqlHandle.examplePlanHandle) AS qp 
	WHERE qp.query_plan IS NOT NULL
	
	
	UPDATE Collection SET CompletedOn = SYSDATETIMEOFFSET() WHERE CollectionId = @CollectionId
	 
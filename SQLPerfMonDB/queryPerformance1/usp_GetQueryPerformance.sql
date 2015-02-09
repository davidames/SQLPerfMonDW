--CREATE PROCEDURE [dbo].[usp_GetQueryPerformance]
	
--AS
/*	

CREATE TABLE #QueryTexts
(
QueryTextFingerPrint binary(8) CONSTRAINT PK_QueryTexts PRIMARY KEY CLUSTERED,
QueryText varchar(max),
SourceDbName sysname NULL
)

CREATE TABLE #QueryPlans
(QueryPlanFingerPrint binary(8) CONSTRAINT PK_QueryPlans PRIMARY KEY CLUSTERED,
QueryPlan xml,
SourceDbName sysname NULL
)
*/
DECLARE @TopRowsPerCategory int = 100,
		@MaxAgeDays int = 7
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
		qs.query_hash as QueryTextFingerPrint
	
FROM   sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_plan_attributes (qs.plan_handle) AS [database_id]

 WHERE
         [database_id].attribute = 'dbid'
         AND qs.last_execution_time > dateAdd(day, -@MaxAgeDays, getdate())	
GROUP BY  qs.query_plan_hash, qs.query_hash,
          DB_NAME (CONVERT (int, [database_id].value)) 
         
         
         )
SELECT 
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
	    QueryPlanFingerPrint
	
	
INTO #PerfData
FROM cteData
WHERE	SortCountExecutions <= @TopRowsPerCategory OR
		SortLogicalReads  <= @TopRowsPerCategory OR
		SortPhysicalReads  <= @TopRowsPerCategory OR
		SortWorkerTime  <= @TopRowsPerCategory OR
		SortElapsedTime  <= @TopRowsPerCategory 
		AND databaseName IS NOT NULL

/* 
	Create SQL Texts Objects
*/	
	;WITH cteUniqueMissing AS 
	(
	SELECT DISTINCT pd.QueryTextFingerPrint
	FROM #PerfData pd
	LEFT JOIN #QueryTexts q ON pd.QueryTextFingerPrint = q.QueryTextFingerPrint
	WHERE q.QueryTextFingerPrint IS NULL
	)


INSERT #QueryTexts
(
	QueryTextFingerPrint,
	QueryText ,
	SourceDbName 
)
	SELECT um.QueryTextFingerPrint, sql.text, db_name(sql.dbid)
	FROM cteUniqueMissing um
	CROSS APPLY
	(
		SELECT TOP 1 pd.exampleSqlHandle
		FROM #PerfData pd
		WHERE	pd.QueryTextFingerPrint = um.QueryTextFingerPrint	
		AND pd.examplePlanHandle IS NOT NULL
	) as sqlHandle
	CROSS APPLY sys.dm_exec_sql_text(sqlHandle.exampleSqlHandle) AS sql 



/* 
	Create SQL Texts Objects
*/	
select * from #perfData

	;WITH cteUniqueMissing AS 
	(
	SELECT DISTINCT pd.QueryPlanFingerPrint
	FROM #PerfData pd
	LEFT JOIN #QueryPlans q ON pd.QueryPlanFingerPrint = q.QueryPlanFingerPrint
	WHERE q.QueryPlanFingerPrint IS NULL
	)

INSERT #QueryPlans
(
	QueryPlanFingerPrint,
	QueryPlan ,
	SourceDbName 
)
	SELECT um.QueryPlanFingerPrint, qp.query_plan, db_name(qp.dbid)
	FROM cteUniqueMissing um
	CROSS APPLY
	(
		SELECT TOP 1 pd.examplePlanHandle
		FROM #PerfData pd
		WHERE	pd.QueryPlanFingerPrint = um.QueryPlanFingerPrint	
		AND pd.examplePlanHandle IS NOT NULL
	) as sqlHandle
	CROSS APPLY sys.dm_exec_query_plan(sqlHandle.examplePlanHandle) AS qp 

	
	SELECT * FROM #PerfData pd
	INNER JOIN #QueryTexts t ON pd.QueryTextFingerPrint = t.QueryTextFingerPrint
	INNER JOIN #QueryPlans p ON pd.QueryPlanFingerPrint = p.QueryPlanFingerPrint
	
		DROP TABLE #PerfData
		
				
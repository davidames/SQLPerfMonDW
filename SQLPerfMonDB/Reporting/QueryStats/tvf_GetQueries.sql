CREATE FUNCTION tvf_GetQueries
(
	 
	 @CollectionID uniqueidentifier 
)
RETURNS TABLE
AS
RETURN  
(


SELECT 
SUBSTRING(t.QueryText, (qp.statementStartOffset/2)+1,
        ((CASE qp.statementEndOffset                
        WHEN -1 THEN DATALENGTH(t.QueryText)        
        ELSE (qp.statementEndOffset - qp.statementStartOffset)/2           
        END)) + 1) as statementText
,
qp.DatabaseName, qp.ExecutionCount, qp.TotalWorkerTime, qp.TotaElapsedTime, qp.TotalLogicalWrites, qp.TotalLogicalReads, qp.TotalPhysicalReads,
CASE qp.TotalWorkerTime WHEN 0 THEN 0 ELSE qp.TotalWorkerTime/qp.ExecutionCount END as AvgWorkingTime,
CASE qp.TotaElapsedTime WHEN 0 THEN 0 ELSE qp.TotaElapsedTime/qp.ExecutionCount END as AvgElapsedTime,
CASE qp.TotalLogicalReads WHEN 0 THEN 0 ELSE qp.TotalLogicalReads/qp.ExecutionCount END as AvgLogicalReads,
CASE qp.TotalLogicalWrites WHEN 0 THEN 0 ELSE qp.TotalLogicalWrites/qp.ExecutionCount END as AvgLogicalWrites,
CASE qp.TotalPhysicalReads WHEN 0 THEN 0 ELSE qp.TotalPhysicalReads/qp.ExecutionCount END as AvgPhysicalReads,
p.queryPlan.value('declare namespace p="http://schemas.microsoft.com/sqlserver/2004/07/showplan"; max(//p:RelOp/@Parallel)', 'float') as IsParrallel,
p.QueryPlan,
p.SourceDbName as PlanSourceDb


FROM QueryPerformance qp
INNER JOIN QueryPlans p on qp.QueryPlanFingerPrint = p.QueryPlanFingerPrint
INNER JOIN QueryTexts t ON qp.QueryTextFingerPrint = t.QueryTextFingerPrint
WHERE qp.CollectionSetID = @CollectionID  

)
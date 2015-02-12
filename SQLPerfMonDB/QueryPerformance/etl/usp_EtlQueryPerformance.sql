
CREATE PROCEDURE [dbo].[usp_EtlQueryPerformance]
	(
	@OriginalCollectionId uniqueidentifier 
	)
	AS
	
DECLARE @CollectionId int
DECLARE @OriginalCollectionId uniqueidentifier 


INSERT DimMachine
(
			MachineName
)
SELECT		DISTINCT c.MachineName
FROM		Collection c
LEFT JOIN	DimMachine m ON c.MachineName = m.MachineName
WHERE		m.MachineId IS NULL
			AND c.CollectionId = @OriginalCollectionId
 

SELECT TOP 1 @CollectionId  = CollectionId
FROM	DimCollection
WHERE OriginalCollectionId = @OriginalCollectionId


IF @CollectionId IS NULL
BEGIN
	INSERT DimCollection (MachineId,  OriginalCollectionId)
	SELECT m.MachineId, c.CollectionId
	FROM	Collection c
	INNER JOIN DimMachine m ON c.MachineName = m.MachineName
	WHERE c.CollectionId = @OriginalCollectionId
	SET @CollectionId = SCOPE_IDENTITY()
END


select @CollectionId

/*
Query Texts
*/

;WITH cteSource 
AS 
(
SELECT qt.QueryTextFingerPrint, qt.QueryText, qt.SourceDbName, qt.CreatedOn, qt.IsDetailRemovedDueToEtl
FROM QueryTexts qt
LEFT JOIN DimQueryText d ON qt.QueryTextFingerPrint = d.QueryTextFingerPrint
WHERE d.QueryTextFingerPrint IS NULL
)


UPDATE cteSource SET IsDetailRemovedDueToEtl = 1
OUTPUT INSERTED.QueryTextFingerPrint, INSERTED.QueryText, INSERTED.SourceDbName, INSERTED.CreatedOn

INTO 
 DimQueryText
(
	QueryTextFingerPrint,
	QueryText,
	SourceDbName,
	CreatedOn
)

UPDATE QueryTexts SET QueryText = NULL WHERE QueryText IS NOT NULL AND IsDetailRemovedDueToEtl = 1





/*
Query Plans
*/

;WITH cteSource 
AS 
(
SELECT qp.QueryPlanFingerPrint, qp.QueryPlan, qp.SourceDbName, qp.CreatedOn, qp.IsDetailRemovedDueToEtl
FROM QueryPlans qp
LEFT JOIN DimQueryPlan d ON qp.QueryPlanFingerPrint = d.QueryPlanFingerPrint
WHERE d.QueryPlanFingerPrint IS NULL
)


UPDATE cteSource SET IsDetailRemovedDueToEtl = 1
OUTPUT INSERTED.QueryPlanFingerPrint, INSERTED.QueryPlan, INSERTED.SourceDbName, INSERTED.CreatedOn

INTO 
 DimQueryPlan
(
	QueryPlanFingerPrint,
	QueryPlan,
	SourceDbName,
	CreatedOn
)

UPDATE QueryPlans SET QueryPlan = NULL WHERE QueryPlan IS NOT NULL AND IsDetailRemovedDueToEtl = 1



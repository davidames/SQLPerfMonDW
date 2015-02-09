CREATE PROCEDURE [dbo].[usp_EtlQueryPerformance]
	(
	@OriginalCollectionId uniqueidentifier 
	)
	AS
DECLARE @CollectionId int


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

	SET @CollectionId = SCOPE_IDENTITY()
END


select @CollectionId


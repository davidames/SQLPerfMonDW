CREATE PROCEDURE [dbo].usp_PerfMonEtlCleanStaging 
(
	@EtlActionExecutionId uniqueidentifier
)	
AS

SELECT 1
WHILE @@ROWCOUNT > 0
BEGIN
	DELETE	TOP (2000) 
	FROM	PerfMonStaging 
	WHERE	EtlActionExecutionId = @EtlActionExecutionId
END  
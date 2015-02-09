CREATE PROCEDURE [dbo].[usp_CreateDefaultEtlAction]
	
AS
	
	IF NOT EXISTS (SELECT * FROM EtlActions)

	INSERT EtlActions
	(
		IsActive
	)
	VALUES 
	(
	1
	)

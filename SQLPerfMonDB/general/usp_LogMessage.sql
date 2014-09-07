CREATE PROCEDURE [dbo].[usp_LogMessage]
	@message nvarchar(max)
AS
RAISERROR (@message, 0, 1) WITH NOWAIT
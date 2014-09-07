


CREATE PROCEDURE [dbo].usp_LogDynamicSql
	@name nvarchar(100),
	@sql nvarchar(max)
AS
DECLARE @message nvarchar(max) = '---- Dynamic SQL: ' + @name + ' -----

'
+ @sql +
'
---- End Of Dynamic SQL-----
'

RAISERROR (@message, 0, 1) WITH NOWAIT

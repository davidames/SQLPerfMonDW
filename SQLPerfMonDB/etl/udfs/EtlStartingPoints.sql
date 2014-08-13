CREATE FUNCTION [dbo].[EtlStartingPoints]
()
RETURNS  TABLE

/*
	Returns the Counter/RecordIndex for where we start the ETL process.  Ie, we will ETL records <= these numbers.

*/
AS

RETURN 


WITH cteMaxCounter AS 
(
	SELECT cd.Guid, Max(cd.CounterID) as MaxCounterID 
	FROM CounterData cd
	GROUP BY Guid
)

SELECT	mc.Guid, mc.MaxCounterID, 
		(SELECT Max(cd.RecordIndex)  FROM CounterData cd WHERE cd.CounterID = mc.MaxCounterID AND cd.Guid = mc.Guid) as MaxRecordIndex
FROM	cteMaxCounter mc



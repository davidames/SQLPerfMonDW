CREATE FUNCTION [dbo].[RecordsToEtl]
(
		@Guid uniqueidentifier,
		@MaxCounterID int,
		@MaxRecordIndex int
)
RETURNS TABLE

AS
RETURN 


SELECT		cdt.MachineName, cdt.CounterName, cdt.InstanceName,
			cd.CounterValue, cd.CounterDateTime 
      
FROM		dbo.CounterDetails cdt
INNER JOIN	dbo.CounterData cd ON cdt.CounterID = cd.CounterID
INNER JOIN	dbo.DisplayToID d ON d.GUID = cd.GUID

WHERE		cd.Guid = @Guid
			AND 
			(
				(cd.CounterId < @MaxCounterId) /* All rows for the previous counter*/
				OR
				(	/* For the current counter, all rows with a record index < this one*/
					(cd.CounterId = @MaxCounterId)
					AND cd.RecordIndex <= @MaxRecordIndex
				)
			)


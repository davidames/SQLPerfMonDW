CREATE PROCEDURE [dbo].[usp_ClearSourceData]
	
		@Guid uniqueidentifier,
		@MaxCounterID int,
		@MaxRecordIndex int
AS
	

SELECT 1
WHILE @@ROWCOUNT > 0
BEGIN

DELETE TOP (2000) FROM CounterData

WHERE		Guid = @Guid
			AND 
			(
				(CounterId < @MaxCounterId) /* All rows for the previous counter*/
				OR
				(	/* For the current counter, all rows with a record index < this one*/
					(CounterId = @MaxCounterId)
					AND RecordIndex <= @MaxRecordIndex
				)
			)
END



CREATE VIEW [dbo].[vw_FileAnalysisLast48Hours]
	AS
SELECT * FROM tvf_FileAnalysisGoingBackFromLatest (48)

GO
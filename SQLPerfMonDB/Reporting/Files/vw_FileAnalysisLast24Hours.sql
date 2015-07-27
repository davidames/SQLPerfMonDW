CREATE VIEW [dbo].[vw_FileAnalysisLast24Hours]
	AS
SELECT * FROM tvf_FileAnalysisGoingBackFromLatest (24)

GO
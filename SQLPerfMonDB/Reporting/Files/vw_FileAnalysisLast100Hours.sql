CREATE VIEW [dbo].[vw_FileAnalysisLast100Hours]
	AS
SELECT * FROM tvf_FileAnalysisGoingBackFromLatest (100)

GO
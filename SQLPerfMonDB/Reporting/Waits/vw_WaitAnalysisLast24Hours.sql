CREATE VIEW vw_WaitAnalysisLast24Hours 
AS 

SELECT * FROM tvf_WaitAnalysisGoingBackFromLatest (24)

GO
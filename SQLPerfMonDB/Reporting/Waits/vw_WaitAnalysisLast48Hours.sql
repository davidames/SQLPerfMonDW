CREATE VIEW vw_WaitAnalysisLast48Hours 
AS 

SELECT * FROM tvf_WaitAnalysisGoingBackFromLatest (48)

GO
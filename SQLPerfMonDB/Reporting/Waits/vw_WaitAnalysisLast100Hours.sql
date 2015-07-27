CREATE VIEW vw_WaitAnalysisLast100Hours 
AS 

SELECT * FROM tvf_WaitAnalysisGoingBackFromLatest (100)

GO
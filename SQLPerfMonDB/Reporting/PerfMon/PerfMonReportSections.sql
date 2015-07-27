CREATE TABLE [dbo].[PerfMonReportSections]
(
	[PerfMonReportSectionId] INT NOT NULL PRIMARY KEY, 
    [PerfMonReportId] INT NOT NULL, 
    [Name] VARCHAR(50) NOT NULL
)

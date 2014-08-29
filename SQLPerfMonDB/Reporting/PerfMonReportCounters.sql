CREATE TABLE [dbo].[PerfMonReportCounters]
(
	[PerfMonReportCounterID] INT NOT NULL PRIMARY KEY, 
    [PerfMonReportSectionID] INT NOT NULL, 
    [CounterName] VARCHAR(1024) NOT NULL,
	CounterInstanceName  varchar(1024) NULL, 
    [SubReportName] VARCHAR(1024) NULL, 
    [CounterDescription] NVARCHAR(MAX) NULL
)

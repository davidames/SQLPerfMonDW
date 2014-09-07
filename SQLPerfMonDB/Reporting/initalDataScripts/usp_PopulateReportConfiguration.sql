CREATE PROCEDURE [dbo].[usp_PopulateReportConfiguration]

AS
	
SET IDENTITY_INSERT PerfMonReports ON 
MERGE INTO [PerfMonReports] AS Target
USING (VALUES
  (1)
) AS Source ([PerfMonReportId])
ON (Target.[PerfMonReportId] = Source.[PerfMonReportId])
WHEN NOT MATCHED BY TARGET THEN
 INSERT([PerfMonReportId])
 VALUES(Source.[PerfMonReportId]);

 SET IDENTITY_INSERT PerfMonReports OFF



MERGE INTO [PerfMonReportSections] AS Target
USING (VALUES
  (1,1,'Performance')
 ,(2,1,'Capacity')
) AS Source ([PerfMonReportSectionId],[PerfMonReportId],[Name])
ON (Target.[PerfMonReportSectionId] = Source.[PerfMonReportSectionId])
WHEN MATCHED AND (
	NULLIF(Source.[PerfMonReportId], Target.[PerfMonReportId]) IS NOT NULL OR NULLIF(Target.[PerfMonReportId], Source.[PerfMonReportId]) IS NOT NULL OR 
	NULLIF(Source.[Name], Target.[Name]) IS NOT NULL OR NULLIF(Target.[Name], Source.[Name]) IS NOT NULL) THEN
 UPDATE SET
 [PerfMonReportId] = Source.[PerfMonReportId], 
[Name] = Source.[Name]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([PerfMonReportSectionId],[PerfMonReportId],[Name])
 VALUES(Source.[PerfMonReportSectionId],Source.[PerfMonReportId],Source.[Name])
;
 
MERGE INTO [PerfMonReportCounters] AS Target
USING (VALUES
  (1,1,'Avg. Disk sec/Read','_Total','subCounterDataWithInstanceSeries','The amount of time, in seconds, each read from the disk takes.  Regular values over 25ms (0.025 seconds) indicate the disk subsytem cannot keep up with the current load')
 ,(2,1,'Avg. Disk sec/Write','_Total','subCounterDataWithInstanceSeries','The amount of time, in seconds, each write to the disk takes.  Regular values over 25ms (0.025 seconds) indicate the disk subsytem cannot keep up with the current load')
 ,(3,2,'Disk Reads & Writes per Second (stacked)',NULL,'subDiskReadsAndWritesPerSecond','The count of reads and writes per second completed by the disk subsystem. Another term for this is IOPs  Each hard drive in an array can handle a certain number of IOPs.  Therefore, the entire disk subsystem has a total number of IOPs it can comfortably support.')
 ,(4,2,'Page life expectancy',NULL,'subCounterDataWithInstanceSeries','The estimated amount of times, in seconds, that an 8k data page will remain cached in the SQL Server buffer pool. Small numbers indicate memory pressure')
 ,(5,2,'% Processor Time','_Total','subCounterDataWithInstanceSeries','The percentage of elapsed time that the processor spends to execute a non-Idle thread.')
) AS Source ([PerfMonReportCounterID],[PerfMonReportSectionID],[CounterName],[CounterInstanceName],[SubReportName],[CounterDescription])
ON (Target.[PerfMonReportCounterID] = Source.[PerfMonReportCounterID])
WHEN MATCHED AND (
	NULLIF(Source.[PerfMonReportSectionID], Target.[PerfMonReportSectionID]) IS NOT NULL OR NULLIF(Target.[PerfMonReportSectionID], Source.[PerfMonReportSectionID]) IS NOT NULL OR 
	NULLIF(Source.[CounterName], Target.[CounterName]) IS NOT NULL OR NULLIF(Target.[CounterName], Source.[CounterName]) IS NOT NULL OR 
	NULLIF(Source.[CounterInstanceName], Target.[CounterInstanceName]) IS NOT NULL OR NULLIF(Target.[CounterInstanceName], Source.[CounterInstanceName]) IS NOT NULL OR 
	NULLIF(Source.[SubReportName], Target.[SubReportName]) IS NOT NULL OR NULLIF(Target.[SubReportName], Source.[SubReportName]) IS NOT NULL OR 
	NULLIF(Source.[CounterDescription], Target.[CounterDescription]) IS NOT NULL OR NULLIF(Target.[CounterDescription], Source.[CounterDescription]) IS NOT NULL) THEN
 UPDATE SET
 [PerfMonReportSectionID] = Source.[PerfMonReportSectionID], 
[CounterName] = Source.[CounterName], 
[CounterInstanceName] = Source.[CounterInstanceName], 
[SubReportName] = Source.[SubReportName], 
[CounterDescription] = Source.[CounterDescription]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([PerfMonReportCounterID],[PerfMonReportSectionID],[CounterName],[CounterInstanceName],[SubReportName],[CounterDescription])
 VALUES(Source.[PerfMonReportCounterID],Source.[PerfMonReportSectionID],Source.[CounterName],Source.[CounterInstanceName],Source.[SubReportName],Source.[CounterDescription])
;

INSERT DimCounter (CounterName)
SELECT 'Disk Reads & Writes per Second (stacked)'
WHERE NOT EXISTS (SELECT * FROM DimCounter WHERE CounterName = 'Disk Reads & Writes per Second (stacked)')



SET IDENTITY_INSERT [KPIConfiguration] ON
/*
MERGE INTO [KPIConfiguration] AS Target
USING (VALUES
  (1,'Avg. Disk sec/Read',NULL,2.5,5.000000000000000e-002,1.000,NULL)
 ,(2,'Avg. Disk sec/Write',NULL,2.50,5.000000000000000e-002,1.0000,NULL)
 ,(3,'Disk Reads & Writes per Second (stacked)',NULL,5.00,8.000000000,1.000000,NULL)
 ,(4,'Page life expectancy',NULL,1.800000000,6.0000000,NULL)
) AS Source ([KPIConfigurationId],[CounterName],[CounterInstanceName],[GreenLevel],[Orangelevel],[RedLine],[MachineName])
ON (Target.[KPIConfigurationId] = Source.[KPIConfigurationId])
WHEN MATCHED AND (
	NULLIF(Source.[CounterName], Target.[CounterName]) IS NOT NULL OR NULLIF(Target.[CounterName], Source.[CounterName]) IS NOT NULL OR 
	NULLIF(Source.[CounterInstanceName], Target.[CounterInstanceName]) IS NOT NULL OR NULLIF(Target.[CounterInstanceName], Source.[CounterInstanceName]) IS NOT NULL OR 
	NULLIF(Source.[GreenLevel], Target.[GreenLevel]) IS NOT NULL OR NULLIF(Target.[GreenLevel], Source.[GreenLevel]) IS NOT NULL OR 
	NULLIF(Source.[Orangelevel], Target.[Orangelevel]) IS NOT NULL OR NULLIF(Target.[Orangelevel], Source.[Orangelevel]) IS NOT NULL OR 
	NULLIF(Source.[RedLine], Target.[RedLine]) IS NOT NULL OR NULLIF(Target.[RedLine], Source.[RedLine]) IS NOT NULL OR 
	NULLIF(Source.[MachineName], Target.[MachineName]) IS NOT NULL OR NULLIF(Target.[MachineName], Source.[MachineName]) IS NOT NULL) THEN
 UPDATE SET
 [CounterName] = Source.[CounterName], 
[CounterInstanceName] = Source.[CounterInstanceName], 
[GreenLevel] = Source.[GreenLevel], 
[Orangelevel] = Source.[Orangelevel], 
[RedLine] = Source.[RedLine], 
[MachineName] = Source.[MachineName]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([KPIConfigurationId],[CounterName],[CounterInstanceName],[GreenLevel],[Orangelevel],[RedLine],[MachineName])
 VALUES(Source.[KPIConfigurationId],Source.[CounterName],Source.[CounterInstanceName],Source.[GreenLevel],Source.[Orangelevel],Source.[RedLine],Source.[MachineName])
;
*/
CREATE TABLE [dbo].[KPIConfiguration]
(
	[KPIConfigurationId] INT NOT NULL Identity PRIMARY KEY, 
    [CounterName] VARCHAR(1024) NOT NULL, 
    [CounterInstanceName] VARCHAR(1024) NULL, 
    [GreenLevel] FLOAT NULL, 
    [Orangelevel] FLOAT NULL, 
    [RedLine] FLOAT NULL, 
    [MachineName] VARCHAR(1024) NULL
)

CREATE TABLE [dbo].[KPIConfiguration]
(
	[KPIConfigurationId] INT NOT NULL Identity PRIMARY KEY, 
    [CounterName] VARCHAR(1024) NOT NULL, 
    [CounterInstanceName] VARCHAR(1024) NULL, 
    [GreenMaxLevel] FLOAT NULL, 
    [OrangeMaxLevel] FLOAT NULL, 
    [IsAboveValues] BIT NOT NULL CONSTRAINT DF_KPIConfiguration_IsAboveValues DEFAULT(0)
)

CREATE TABLE [dbo].[DimMachine]
(
	[MachineId] SMALLINT NOT NULL Identity , 
    [MachineName] VARCHAR(120) NOT NULL,
	[MachineEnviroment] VARCHAR(50) NULL, 
    [MachineType] VARCHAR(50) NULL, 
    CONSTRAINT PK_DimMacheine Primary Key (MachineId)
)

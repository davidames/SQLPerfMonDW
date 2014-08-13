CREATE TABLE [dbo].[DimMachine]
(
	[MachineId] SMALLINT NOT NULL Identity , 
    [MachineName] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_DimMacheine Primary Key (MachineId)
)

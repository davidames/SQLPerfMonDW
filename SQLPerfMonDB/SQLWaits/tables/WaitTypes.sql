CREATE TABLE WaitTypes 
(
WaitTypeId smallint identity(1,1),
Name nvarchar(60),
IsMonitored BIT CONSTRAINT DF_WaitTypes_IsMonitored DEFAULT (0)
CONSTRAINT PK_WaitTypes PRIMARY KEY CLUSTERED (WaitTypeId)
)

GO
CREATE UNIQUE INDEX IX_WaitTypes_Name_1 ON WaitTypes (IsMonitored, Name) WHERE IsMonitored = 1


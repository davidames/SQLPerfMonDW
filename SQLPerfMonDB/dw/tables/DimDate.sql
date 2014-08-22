CREATE TABLE [dbo].[DimDate]
(
	[DateId] INT NOT NULL Identity, 
    [DateNoTime] DATE NOT NULL, 
    [FullDateTime] DATETIME NOT NULL, 
    [DateToTheHour] DATETIME NOT NULL, 
    [DateToTheMinute] DATETIME NOT NULL, 
    [DayOfWeek] TINYINT NOT NULL, 
    [Hour] TINYINT NOT NULL,
	CONSTRAINT PK_DimDate PRIMARY KEY (DateId)
)
GO

CREATE INDEX IX_DimDateTime_FullDateTime_1 ON DimDate(FullDateTime)

GO

CREATE NONCLUSTERED INDEX IX_DimDate_DateNoTime_1
ON [dbo].[DimDate] ([DateNoTime])
INCLUDE ([DateId],[DateToTheHour],[DateToTheMinute],[DayOfWeek],[Hour])

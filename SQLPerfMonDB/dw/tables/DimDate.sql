﻿CREATE TABLE [dbo].[DimDate]
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

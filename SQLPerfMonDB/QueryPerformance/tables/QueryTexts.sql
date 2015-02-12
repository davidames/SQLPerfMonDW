CREATE TABLE QueryTexts
(
QueryTextFingerPrint binary(8) CONSTRAINT PK_QueryTexts PRIMARY KEY CLUSTERED,
QueryText varchar(max) NULL,
SourceDbName sysname NULL,
IsDetailRemovedDueToEtl bit NOT NULL CONSTRAINT DF_QueryTexts_IsDetailRemovedDueToEtl DEFAULT (0),
CreatedOn DateTimeOffset NOT NULL CONSTRAINT DF_QueryTexts_CreatedOn DEFAULT SysDateTimeOffset()

)
CREATE TABLE [dbo].[CounterData] (
    [GUID]            UNIQUEIDENTIFIER NOT NULL,
    [CounterID]       INT              NOT NULL,
    [RecordIndex]     INT              NOT NULL,
    [CounterDateTime] CHAR (24)        NOT NULL,
    [CounterValue]    FLOAT (53)       NOT NULL,
    [FirstValueA]     INT              NULL,
    [FirstValueB]     INT              NULL,
    [SecondValueA]    INT              NULL,
    [SecondValueB]    INT              NULL,
    [MultiCount]      INT              NULL,
	
    PRIMARY KEY CLUSTERED ([GUID] ASC, [CounterID] ASC, [RecordIndex] ASC)
);

GO



GO
EXECUTE sp_tableoption @TableNamePattern = N'[dbo].[CounterData]', @OptionName = N'table lock on bulk load', @OptionValue = N'TRUE';


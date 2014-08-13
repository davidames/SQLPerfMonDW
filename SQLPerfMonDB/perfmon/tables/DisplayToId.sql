CREATE TABLE [dbo].[DisplayToID] (
    [GUID]            UNIQUEIDENTIFIER NOT NULL,
    [RunID]           INT              NULL,
    [DisplayString]   VARCHAR (1024)   NOT NULL,
    [LogStartTime]    CHAR (24)        NULL,
    [LogStopTime]     CHAR (24)        NULL,
    [NumberOfRecords] INT              NULL,
    [MinutesToUTC]    INT              NULL,
    [TimeZoneName]    CHAR (32)        NULL,
    PRIMARY KEY CLUSTERED ([GUID] ASC),
    UNIQUE NONCLUSTERED ([DisplayString] ASC)
);


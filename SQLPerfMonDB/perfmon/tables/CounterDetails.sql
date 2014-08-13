CREATE TABLE [dbo].[CounterDetails] (
    [CounterID]      INT            IDENTITY (1, 1) NOT NULL,
    [MachineName]    VARCHAR (1024) NOT NULL,
    [ObjectName]     VARCHAR (1024) NOT NULL,
    [CounterName]    VARCHAR (1024) NOT NULL,
    [CounterType]    INT            NOT NULL,
    [DefaultScale]   INT            NOT NULL,
    [InstanceName]   VARCHAR (1024) NULL,
    [InstanceIndex]  INT            NULL,
    [ParentName]     VARCHAR (1024) NULL,
    [ParentObjectID] INT            NULL,
    [TimeBaseA]      INT            NULL,
    [TimeBaseB]      INT            NULL,
    PRIMARY KEY CLUSTERED ([CounterID] ASC)
);


CREATE TABLE QueryPlans
(QueryPlanFingerPrint binary(8) CONSTRAINT PK_QueryPlans PRIMARY KEY CLUSTERED,
QueryPlan xml NOT NULL,
SourceDbName sysname NULL,
IsDetailRemovedDueToEtl bit NOT NULL CONSTRAINT DF_QueryPlans_IsDetailRemovedDueToEtl DEFAULT (0),
CreatedOn DateTimeOffset NOT NULL CONSTRAINT DF_QueryPlans_CreatedOn DEFAULT SysDateTimeOffset()
)

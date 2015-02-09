CREATE TABLE [dbo].[DimQueryPlan]
(
	QueryPlanId int identity CONSTRAINT PK_DimQueryPlan PRIMARY KEY CLUSTERED,
	QueryPlanFingerPrint binary(8) ,
	QueryPlan xml NOT NULL,
	SourceDbName sysname NULL,
	CreatedOn DateTimeOffset NOT NULL
)
GO
CREATE UNIQUE INDEX UIX_DimQueryPlan_QueryPlanFingerPrint ON DimQueryPlan(QueryPlanFingerPrint)
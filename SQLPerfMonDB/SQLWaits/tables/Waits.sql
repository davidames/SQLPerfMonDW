CREATE TABLE Waits
(
	WaitSnapshotId bigint NOT NULL,
	WaitTypeId smallint NOT NULL CONSTRAINT FK_Waits_WaitTypeId FOREIGN KEY REFERENCES WaitTypes(WaitTypeId),
	WaitingTasksCount bigint,
	WaitTimeMs bigint,
	SignalWaitTimeMs bigint
	CONSTRAINT PK_Waits PRIMARY KEY CLUSTERED (WaitSnapshotId, WaitTypeId)
)
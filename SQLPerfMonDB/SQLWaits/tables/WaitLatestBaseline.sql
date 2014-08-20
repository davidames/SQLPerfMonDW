CREATE TABLE WaitLatestBaseline
(
	WaitSnapshotId bigint NOT NULL,
	WaitTypeId smallint NOT NULL,
	Waiting_tasks_count bigint,
	Wait_time_ms bigint,
	Signal_wait_time_ms bigint
	CONSTRAINT PK_WaitLatestBaseline PRIMARY KEY CLUSTERED (WaitSnapshotId, WaitTypeId)
)
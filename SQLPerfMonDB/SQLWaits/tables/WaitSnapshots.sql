CREATE TABLE WaitSnapshots
 (
 WaitSnapshotId bigint identity(1,1),
 ServerName nvarchar(256) CONSTRAINT DF_LatestBaseline_ServerName DEFAULT @@ServerName,
 DateOccured DateTimeOffset CONSTRAINT DF_LatestBaseline_DateOccured DEFAULT SysDateTimeOffset(),
 DurationSeconds int null,
 CONSTRAINT PK_WaitSnapshots  PRIMARY KEY (WaitSnapshotId)
 )
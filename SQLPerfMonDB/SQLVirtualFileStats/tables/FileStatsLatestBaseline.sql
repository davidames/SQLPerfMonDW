CREATE TABLE [dbo].[FileStatsLatestBaseline]
(
WaitSnapshotId bigint NOT NULL,
io_stall	bigint,
io_stall_read_ms	bigint,
io_stall_write_ms	bigint,
num_of_reads	bigint,
num_of_writes	bigint,
size_on_disk_mb	numeric,
database_id int,
dbname	[sys].[sysname],
fileName	sysname,
file_id	smallint
CONSTRAINT  PK_FileStatsLatestBaseline PRIMARY KEY (WaitSnapshotId,database_id, file_id )
)

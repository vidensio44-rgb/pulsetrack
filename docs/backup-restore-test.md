# PulseTrack Backup and Restore Test

## Objective

Verify that a PostgreSQL custom-format backup of the `pulsetrack_test` database can be restored into a separate database and that the restored data matches the original table counts.

## Environment

- Database engine: PostgreSQL 18.6
- Backup tool: `pg_dump` 18.6
- Restore tool: `pg_restore` 18.6
- Source database: `pulsetrack_test`
- Restore verification database: `pulsetrack_restore_check`
- Backup format: Custom archive (`-F c`)
- Backup file: `backups/pulsetrack_test_2026-10-20.dump`

## Procedure

1. Checked the installed PostgreSQL client tool versions.
2. Created a custom-format backup of `pulsetrack_test` using `pg_dump`.
3. Inspected the backup archive using `pg_restore --list`.
4. Confirmed that `pulsetrack_restore_check` did not exist before creating it.
5. Created the separate restore verification database.
6. Restored the archive into `pulsetrack_restore_check` using `pg_restore`.
7. Queried the restored database to compare important table row counts.

## Results

| Table | Expected rows | Restored rows | Result |
|---|---:|---:|---|
| `tenants` | 2 | 2 | Pass |
| `users` | 3 | 3 | Pass |
| `events` | 7 | 7 | Pass |
| `products` | 3 | 3 | Pass |
| `orders` | 3 | 3 | Pass |
| `order_items` | 3 | 3 | Pass |
| `audit_log` | 3 | 3 | Pass |

## Outcome

The backup archive was readable, and the restored database returned the expected row counts for all seven checked tables.

This provides evidence that the backup can be restored and that the selected data was recovered correctly.

## Limitations

- Validation focused on archive readability and row counts for the listed tables.
- This test did not independently verify every schema object, index, trigger, security policy, or application workflow.
- The recorded result is a local test, not a production disaster-recovery certification.
- The backup file is kept locally and excluded from Git to avoid publishing database dumps.

## Safety Measures

- The source database `pulsetrack_test` was not intentionally modified during the restore.
- The restore was performed into a separate database named `pulsetrack_restore_check`.
- The main database `pulsetrack` was not used as the restore target.
- Database passwords were not written into the report or repository.

## Conclusion

The PulseTrack backup-and-restore test passed the archive inspection and selected row-count checks. Further validation of database objects and security behavior would provide stronger assurance for a production deployment.
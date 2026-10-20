# PulseTrack Audit Logging

## Purpose

PulseTrack records changes to orders in the `audit_log` table. Each audit entry records the table, record ID, action, timestamp, actor, and previous and new row data where applicable.

## Identifying the actor

Migration `V7__audit_actor_tracking.sql` updates the `audit_order_changes()` trigger function.

The function reads the transaction's `app.current_user_id` setting. If the setting is missing or empty, it falls back to PostgreSQL's `CURRENT_USER`.

For example, an application can set the actor within a transaction:

```sql
BEGIN;

SET LOCAL app.current_tenant = '1001';
SET LOCAL app.current_user_id = 'application-user-123';

-- Perform the authorized order operation here.

COMMIT;
```

`SET LOCAL` keeps the setting limited to the current transaction. The application should set the actor from its authenticated identity for every transaction that changes audited data.

## Security limitation

The `app.current_user_id` setting is a session setting, not proof of identity. A database client with sufficient access may set it to an arbitrary value.

The application must derive the actor from a trusted authentication system and must not accept an unverified actor ID from a client. Database permissions and application access controls should restrict who can change data and audit records.

When the setting is not supplied, the fallback records the PostgreSQL role, which may represent a shared application account rather than an individual person.

## Verification

Migration V7 was applied to the `pulsetrack_test` database.

Two rollback-based tests were performed:

1. With `app.current_user_id` set to `test-actor-123`, the audit function recorded `test-actor-123`.
2. Without that setting, the audit function recorded `postgres`.

Both tests were rolled back. A follow-up query confirmed that order `1003` remained `pending` and no test-generated `UPDATE` audit entries for that order persisted.

These checks verify actor selection and rollback behavior in the test database; they do not constitute a production security audit.
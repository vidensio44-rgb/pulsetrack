# PulseTrack — Real-Time Analytics Platform

PulseTrack is a PostgreSQL database capstone project demonstrating multi-tenant data management, database migrations, audit logging, row-level security, and analytics queries.

## Features

- PostgreSQL relational database design.
- Version-controlled schema migrations using Flyway.
- Tenant-aware tables and relationships.
- Indexes for common query patterns.
- Audit logging for order changes.
- Row-Level Security (RLS) for tenant isolation.
- Demo data for testing.
- Five SQL analytics queries.
- Query performance analysis using EXPLAIN ANALYZE.

## Technology Stack

- PostgreSQL 18
- Flyway
- SQL
- Git and GitHub

## Project Structure

- `migrations/` — database schema, indexes, audit triggers, security policies, and demo data.
- `queries/` — analytics SQL queries.
- `docs/query-performance.md` — query performance findings.
- `backups/` — local database backup workspace.
- `scripts/` — project scripts.
- `flyway.toml` — Flyway configuration.

## Database Setup

Install PostgreSQL and Flyway before running the migrations.

Create a dedicated test database if it does not already exist:

```sql
CREATE DATABASE pulsetrack_test;
```

Connect to the test database:

```bash
psql -U postgres -h 127.0.0.1 -d pulsetrack_test
```

## Run Flyway Migrations

From Git Bash, enter your PostgreSQL password without displaying it:

```bash
read -s -p "PostgreSQL password: " FLYWAY_PASSWORD; echo
export FLYWAY_PASSWORD
```

Run migrations against the test environment:

```bash
/c/Users/UBUNTU/Downloads/flyway-commandline-13.10.3-windows-x64/flyway-13.10.3/flyway.cmd -environment=test migrate
```

Check migration status:

```bash
/c/Users/UBUNTU/Downloads/flyway-commandline-13.10.3-windows-x64/flyway-13.10.3/flyway.cmd -environment=test info
```

Clear the temporary password when finished:

```bash
unset FLYWAY_PASSWORD
```

The test database should show migrations V1 through V5 as successful.

**Safety:** Test migrations before using another environment. Do not run destructive commands such as `flyway clean` against your main database.

## Analytics Queries

Run an individual query from the project directory:

```bash
psql -U postgres -h 127.0.0.1 -d pulsetrack_test -f queries/01_daily_active_users.sql
```

Available queries:

| File | Purpose |
|---|---|
| `01_daily_active_users.sql` | Daily active users by tenant |
| `02_event_counts_by_type.sql` | Event counts by type and tenant |
| `03_user_conversion_rate.sql` | Percentage of page-viewing users who also made a purchase during the reporting period |
| `04_revenue_by_product.sql` | Revenue from completed orders by product |
| `05_orders_by_status.sql` | Order counts and values grouped by status |

The demo data and reporting queries use September 2026 dates.

## Query Performance

The analytics queries were tested with PostgreSQL `EXPLAIN (ANALYZE, BUFFERS)`. Findings are documented in `docs/query-performance.md`.

The sample dataset is small, so recorded execution times are illustrative and are not production-scale benchmarks.

## Security Notes

- Never commit passwords, private keys, or `.env` files.
- Supply database credentials securely through your local environment.
- The RLS policies use the `app.current_tenant` session setting.
- A real application must authenticate users and securely establish tenant context. It must not trust users to select arbitrary tenant IDs.

## Future Improvements

- Automated event ingestion.
- Redis Streams integration.
- Analytics dashboards.
- Monitoring and alerting.
- Automated backup and restore testing.

## Author

Vidensio Oyoo

## License

No license has been specified yet.
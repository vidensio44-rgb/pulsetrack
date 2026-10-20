# PulseTrack Query Performance Report

## 1. Purpose

This document records the initial PostgreSQL execution-plan tests for
the five analytics queries in the PulseTrack project.

Tests were run against the isolated `pulsetrack_test` database using
`EXPLAIN (ANALYZE, BUFFERS)`.

## 2. Results Summary

| Query | Execution Time (ms) | Planning Time (ms) | Main Execution Strategy |
|---|---:|---:|---|
| Daily Active Users | 0.322 | 7.667 | Index Scan on events |
| Event Counts by Type | 0.212 | 0.505 | Index Scan on events |
| User Conversion Rate | 0.199 | 0.571 | Index Scan on events |
| Revenue by Product | 0.391 | 23.831 | Hash Join, Nested Loop, and Index Scan |
| Orders by Status | 0.293 | 0.361 | Sequential Scan and HashAggregate |

## 3. Query-by-Query Findings

### Query 1: Daily Active Users

- Execution time: 0.322 ms
- Planning time: 7.667 ms
- PostgreSQL used an index scan on `events_default_pkey`.
- The event-time range condition restricted the rows scanned.
- The query returned two tenant/date groups.

### Query 2: Event Counts by Type

- Execution time: 0.212 ms
- Planning time: 0.505 ms
- PostgreSQL used an index scan on `events_default_pkey`.
- Seven demo events produced five tenant/event-type groups.

### Query 3: User Conversion Rate

- Execution time: 0.199 ms
- Planning time: 0.571 ms
- PostgreSQL used an index scan on `events_default_pkey`.
- The plan used aggregation by tenant and user, followed by aggregation
  by tenant.
- The query returned conversion rates for two tenants.

### Query 4: Revenue by Product

- Execution time: 0.391 ms
- Planning time: 23.831 ms
- PostgreSQL used sequential scans on the small `products` and `orders`
  tables, plus an index scan on `order_items` using
  `idx_order_items_tenant_product`.
- The plan included a Hash Join and a Nested Loop.
- Two product revenue rows were returned.
- The planning time was noticeably higher in this run. This single
  observation is not enough to establish a persistent performance issue.

### Query 5: Orders by Status

- Execution time: 0.293 ms
- Planning time: 0.361 ms
- PostgreSQL used a sequential scan on `orders`.
- A HashAggregate grouped the three demo orders by tenant, status,
  and currency.
- The query returned three groups.

## 4. Interpretation

The event analytics queries used the event-time index to help retrieve
rows in the requested time range.

The revenue query combined joins with an index scan on `order_items`.
Sequential scans on `orders` and `products` are reasonable for these
very small demo tables because reading the whole table can be cheaper
than using an index.

The orders-by-status query also used a sequential scan. Only three
orders were present, so an index was not necessary for this test.

## 5. Limitations

- These tests used a small demonstration dataset.
- Execution times are from individual runs and can vary between runs.
- The results do not establish performance under production traffic.
- Further testing should use a larger representative dataset and
  compare execution plans, buffer activity, and execution times.
- Query 3 measures users who had both a page-view event and a purchase
  event in the reporting month. It does not prove that the page view
  happened before the purchase.

## 6. Conclusion

All five analytics queries executed successfully against the test
database. The observed plans show PostgreSQL using index scans,
sequential scans, aggregation, and joins as appropriate to the query
and the small dataset.

These results provide an initial performance baseline for future
optimization and larger-scale testing.

## 7. Monthly Event Partitioning — V6

### Implementation

Migration `V6__monthly_event_partition.sql` creates the dedicated range partition `events_2026_09` for event timestamps from 1 September 2026 (inclusive) to 1 October 2026 (exclusive).

Existing September events were moved from `events_default` into the new partition through the parent `events` table.

### Data Validation

- Events in `events_2026_09`: 7
- Total events in `events`: 7
- September events in the reporting range: 7
- Data preservation check: passed

### Partition-Pruning Test

The following query was tested using `EXPLAIN (ANALYZE, BUFFERS)` against `pulsetrack_test`:

```sql
SELECT event_id, event_time
FROM events
WHERE event_time >= TIMESTAMPTZ '2026-09-01 00:00:00+00'
  AND event_time < TIMESTAMPTZ '2026-10-01 00:00:00+00';
```

PostgreSQL used an index-only scan on `events_2026_09` and returned all seven matching rows. The plan did not scan `events_default`, demonstrating partition pruning for this date range.

- Execution time: 0.115 ms
- Planning time: 3.989 ms
- Shared buffer hits reported by the execution plan: 2

### Interpretation and Limitations

The execution plan confirms that PostgreSQL can exclude the default partition for this September query. The measured execution time reflects a small demonstration dataset and a single run; it does not establish a production-scale performance improvement.

Future monthly partitions should be created before their date ranges are needed, with a process for monitoring and managing the default partition.

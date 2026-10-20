# PulseTrack — Real-Time Analytics Platform

## 1. Project Overview
PulseTrack collects user activity events, processes incoming events through Redis Streams, stores event history in PostgreSQL, and supports analytical reporting.

## 2. Problem Statement
Applications generate large volumes of user activity data. Analysing this data can become slow as it grows. PulseTrack aims to provide reliable event ingestion, efficient storage, and optimised analytical queries.

## 3. Objectives
- Process incoming events using Redis Streams.
- Store event history in PostgreSQL.
- Partition event data by time where appropriate.
- Support conversion funnel, user retention, and revenue analysis.
- Optimise queries using indexes and execution-plan analysis.
- Use dimension tables and materialized views for reporting.
- Monitor system performance with Prometheus and Grafana.
- Implement and test backup and recovery procedures.
- Document database security and replication options.

## 4. Main Entities
- Tenants
- Users
- Sessions
- Events
- Products
- Orders
- Order Items

## 5. Functional Requirements
1. Accept and process user activity events.
2. Associate events with tenants, users, and sessions where applicable.
3. Store historical events and support time-range queries.
4. Calculate conversion funnels, retention, and revenue.
5. Provide five analytical queries with before-and-after performance evidence.
6. Support summary reporting and database recovery.
7. Apply controlled access and tenant isolation.

## 6. Non-Functional Requirements
- Measure actual query performance using EXPLAIN ANALYZE.
- Target sub-second responses for selected analytical queries on a defined test dataset.
- Use suitable partitioning and indexes based on measurements.
- Monitor database health and resource usage.
- Document backup, restoration, and replication limitations.
- Handle duplicate events and processing failures safely.

## 7. Proposed Technology
- PostgreSQL 18.6
- Redis Streams
- Flyway for database migrations, subject to setup verification
- Prometheus and Grafana
- dbdiagram.io for ER diagram design

## 8. Deliverables
1. Requirements document and ER diagram.
2. Versioned, repeatable database migrations.
3. Integrated streaming and relational storage.
4. Five analytical queries with performance comparisons.
5. Backup and restore evidence.
6. Security checklist and implementation evidence.
7. Monitoring configuration and final presentation.

## 9. Assumptions and Limitations
PostgreSQL is installed and working. Other components must be checked before integration. Performance targets must be verified through testing rather than assumed. Advanced features will be implemented according to the available environment and assignment requirements.

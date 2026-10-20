
-- Create a dedicated partition for September 2026 events.
-- Preserve existing rows currently stored in events_default.

CREATE TEMP TABLE events_september_2026_move
ON COMMIT DROP
AS
SELECT
    event_id,
    event_time,
    tenant_id,
    user_id,
    session_id,
    event_type,
    properties
FROM events_default
WHERE event_time >= TIMESTAMPTZ '2026-09-01 00:00:00+00'
  AND event_time <  TIMESTAMPTZ '2026-10-01 00:00:00+00';

-- Remove these rows from the default partition so PostgreSQL
-- can safely create the new date-bounded partition.
DELETE FROM events_default
WHERE event_time >= TIMESTAMPTZ '2026-09-01 00:00:00+00'
  AND event_time <  TIMESTAMPTZ '2026-10-01 00:00:00+00';

CREATE TABLE events_2026_09
    PARTITION OF events
    FOR VALUES FROM ('2026-09-01 00:00:00+00')
                 TO ('2026-10-01 00:00:00+00');

-- Insert through the parent table so PostgreSQL routes rows
-- into events_2026_09.
INSERT INTO events (
    event_id,
    event_time,
    tenant_id,
    user_id,
    session_id,
    event_type,
    properties
)
SELECT
    event_id,
    event_time,
    tenant_id,
    user_id,
    session_id,
    event_type,
    properties
FROM events_september_2026_move;

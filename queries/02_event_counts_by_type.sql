-- PulseTrack Analytics 2: Event Counts by Type
-- Count each event type for each tenant.

SELECT
    tenant_id,
    event_type,
    COUNT(*) AS total_events
FROM events
WHERE event_time >= TIMESTAMPTZ '2026-09-01 00:00:00+03'
  AND event_time <  TIMESTAMPTZ '2026-10-01 00:00:00+03'
GROUP BY
    tenant_id,
    event_type
ORDER BY
    tenant_id,
    total_events DESC,
    event_type;

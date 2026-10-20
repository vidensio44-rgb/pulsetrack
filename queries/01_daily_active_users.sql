-- PulseTrack Analytics 1: Daily Active Users (DAU)
-- Count unique active users per tenant per day.

SELECT
    tenant_id,
    DATE(event_time) AS activity_date,
    COUNT(DISTINCT user_id) AS daily_active_users
FROM events
WHERE event_time >= TIMESTAMPTZ '2026-09-01 00:00:00+03'
  AND event_time <  TIMESTAMPTZ '2026-10-01 00:00:00+03'
GROUP BY
    tenant_id,
    DATE(event_time)
ORDER BY
    activity_date,
    tenant_id;

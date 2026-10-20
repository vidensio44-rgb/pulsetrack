-- PulseTrack Analytics 3: User Conversion Rate
-- Calculate the percentage of users who viewed a page
-- and also made a purchase during September 2026.

WITH user_activity AS (
    SELECT
        tenant_id,
        user_id,
        BOOL_OR(event_type = 'page_view') AS viewed_page,
        BOOL_OR(event_type = 'purchase') AS made_purchase
    FROM events
    WHERE event_time >= TIMESTAMPTZ '2026-09-01 00:00:00+03'
      AND event_time <  TIMESTAMPTZ '2026-10-01 00:00:00+03'
      AND user_id IS NOT NULL
    GROUP BY
        tenant_id,
        user_id
)
SELECT
    tenant_id,
    COUNT(*) FILTER (WHERE viewed_page) AS page_view_users,
    COUNT(*) FILTER (
        WHERE viewed_page AND made_purchase
    ) AS converted_users,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE viewed_page AND made_purchase
        ) / NULLIF(
            COUNT(*) FILTER (WHERE viewed_page),
            0
        ),
        2
    ) AS conversion_rate_percent
FROM user_activity
GROUP BY tenant_id
ORDER BY tenant_id;

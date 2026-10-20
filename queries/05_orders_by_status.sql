-- PulseTrack Analytics 5: Orders Grouped by Status
-- Count orders and sum their recorded total amounts by tenant and status.

SELECT
    tenant_id,
    order_status,
    currency,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_order_value
FROM orders
GROUP BY
    tenant_id,
    order_status,
    currency
ORDER BY
    tenant_id,
    order_status;

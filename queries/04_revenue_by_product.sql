-- PulseTrack Analytics 4: Revenue by Product
-- Calculate revenue from completed orders for each product and tenant.
-- Revenue uses recorded order-item prices, not current product prices.

SELECT
    o.tenant_id,
    p.product_id,
    p.product_name,
    p.currency,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders AS o
JOIN order_items AS oi
    ON oi.tenant_id = o.tenant_id
   AND oi.order_id = o.order_id
JOIN products AS p
    ON p.tenant_id = oi.tenant_id
   AND p.product_id = oi.product_id
WHERE o.order_status = 'completed'
GROUP BY
    o.tenant_id,
    p.product_id,
    p.product_name,
    p.currency
ORDER BY
    o.tenant_id,
    total_revenue DESC;

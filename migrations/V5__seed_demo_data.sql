
-- PulseTrack V5: Demonstration data
-- Synthetic data only; no real personal information.

INSERT INTO tenants (tenant_id, tenant_name)
VALUES
    (1001, 'Northstar Demo'),
    (1002, 'Southwind Demo');

INSERT INTO users (user_id, tenant_id, email, created_at)
VALUES
    (1001, 1001, 'amina@example.test', '2026-09-01 09:00:00+03'),
    (1002, 1001, 'brian@example.test', '2026-09-02 10:00:00+03'),
    (1003, 1002, 'chao@example.test', '2026-09-03 11:00:00+03');

INSERT INTO sessions (
    session_id, tenant_id, user_id, started_at, ended_at
)
VALUES
    ('10000000-0000-4000-8000-000000000001', 1001, 1001,
     '2026-09-10 09:00:00+03', '2026-09-10 09:20:00+03'),
    ('10000000-0000-4000-8000-000000000002', 1001, 1002,
     '2026-09-10 10:00:00+03', '2026-09-10 10:12:00+03'),
    ('10000000-0000-4000-8000-000000000003', 1002, 1003,
     '2026-09-11 11:00:00+03', '2026-09-11 11:18:00+03');

INSERT INTO events (
    event_time, event_id, tenant_id, user_id, session_id,
    event_type, properties
)
VALUES
    ('2026-09-10 09:01:00+03', 1001, 1001, 1001,
     '10000000-0000-4000-8000-000000000001',
     'page_view', '{"page": "home"}'),
    ('2026-09-10 09:05:00+03', 1002, 1001, 1001,
     '10000000-0000-4000-8000-000000000001',
     'product_view', '{"product_id": 1001}'),
    ('2026-09-10 09:10:00+03', 1003, 1001, 1001,
     '10000000-0000-4000-8000-000000000001',
     'purchase', '{"order_id": 1001}'),
    ('2026-09-10 10:01:00+03', 1004, 1001, 1002,
     '10000000-0000-4000-8000-000000000002',
     'page_view', '{"page": "home"}'),
    ('2026-09-10 10:04:00+03', 1005, 1001, 1002,
     '10000000-0000-4000-8000-000000000002',
     'product_view', '{"product_id": 1002}'),
    ('2026-09-11 11:01:00+03', 1006, 1002, 1003,
     '10000000-0000-4000-8000-000000000003',
     'page_view', '{"page": "home"}'),
    ('2026-09-11 11:05:00+03', 1007, 1002, 1003,
     '10000000-0000-4000-8000-000000000003',
     'purchase', '{"order_id": 1002}');

INSERT INTO products (
    product_id, tenant_id, product_name, current_price, currency
)
VALUES
    (1001, 1001, 'Analytics Starter', 1500.00, 'KES'),
    (1002, 1001, 'Analytics Pro', 4500.00, 'KES'),
    (1003, 1002, 'Insights Basic', 2000.00, 'KES');

INSERT INTO orders (
    order_id, tenant_id, user_id, order_time,
    order_status, currency, total_amount
)
VALUES
    (1001, 1001, 1001, '2026-09-10 09:10:00+03',
     'completed', 'KES', 1500.00),
    (1002, 1002, 1003, '2026-09-11 11:05:00+03',
     'completed', 'KES', 2000.00),
    (1003, 1001, 1002, '2026-09-12 14:30:00+03',
     'pending', 'KES', 4500.00);

INSERT INTO order_items (
    order_item_id, tenant_id, order_id, product_id,
    quantity, unit_price
)
VALUES
    (1001, 1001, 1001, 1001, 1, 1500.00),
    (1002, 1002, 1002, 1003, 1, 2000.00),
    (1003, 1001, 1003, 1002, 1, 4500.00);

-- Keep identity sequences ahead of the explicit demo IDs.
SELECT setval(pg_get_serial_sequence('tenants', 'tenant_id'),
              GREATEST((SELECT MAX(tenant_id) FROM tenants), 1));
SELECT setval(pg_get_serial_sequence('users', 'user_id'),
              GREATEST((SELECT MAX(user_id) FROM users), 1));
SELECT setval(pg_get_serial_sequence('products', 'product_id'),
              GREATEST((SELECT MAX(product_id) FROM products), 1));
SELECT setval(pg_get_serial_sequence('orders', 'order_id'),
              GREATEST((SELECT MAX(order_id) FROM orders), 1));
SELECT setval(pg_get_serial_sequence('order_items', 'order_item_id'),
              GREATEST((SELECT MAX(order_item_id) FROM order_items), 1));
SELECT setval(pg_get_serial_sequence('events', 'event_id'),
              GREATEST((SELECT MAX(event_id) FROM events), 1));

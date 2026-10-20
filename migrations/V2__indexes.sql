
-- PulseTrack V2: Performance indexes
-- Managed by Flyway

-- Find users belonging to a tenant by creation date.
CREATE INDEX idx_users_tenant_created
    ON users (tenant_id, created_at);

-- Find sessions for a tenant ordered by start time.
CREATE INDEX idx_sessions_tenant_started
    ON sessions (tenant_id, started_at);

-- Support event analytics by tenant and time.
CREATE INDEX idx_events_tenant_time
    ON events (tenant_id, event_time);

-- Find events by type within a tenant and time range.
CREATE INDEX idx_events_tenant_type_time
    ON events (tenant_id, event_type, event_time);

-- Support tenant product lookups.
CREATE INDEX idx_products_tenant_name
    ON products (tenant_id, product_name);

-- Support tenant order reports by date.
CREATE INDEX idx_orders_tenant_time
    ON orders (tenant_id, order_time);

-- Support order reports filtered by status and date.
CREATE INDEX idx_orders_tenant_status_time
    ON orders (tenant_id, order_status, order_time);

-- Find order items belonging to an order.
CREATE INDEX idx_order_items_tenant_order
    ON order_items (tenant_id, order_id);

-- Support product sales analysis.
CREATE INDEX idx_order_items_tenant_product
    ON order_items (tenant_id, product_id);

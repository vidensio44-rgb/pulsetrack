
-- PulseTrack V7: Support application-level audit actors.
-- The application should set app.current_user_id from trusted,
-- authenticated user information within the current transaction.

CREATE OR REPLACE FUNCTION audit_order_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    actor TEXT;
BEGIN
    actor := COALESCE(
        NULLIF(current_setting('app.current_user_id', true), ''),
        CURRENT_USER
    );

    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (
            table_name, record_id, action, changed_by,
            old_data, new_data
        )
        VALUES (
            TG_TABLE_NAME,
            NEW.order_id::TEXT,
            TG_OP,
            actor,
            NULL,
            to_jsonb(NEW)
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (
            table_name, record_id, action, changed_by,
            old_data, new_data
        )
        VALUES (
            TG_TABLE_NAME,
            NEW.order_id::TEXT,
            TG_OP,
            actor,
            to_jsonb(OLD),
            to_jsonb(NEW)
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (
            table_name, record_id, action, changed_by,
            old_data, new_data
        )
        VALUES (
            TG_TABLE_NAME,
            OLD.order_id::TEXT,
            TG_OP,
            actor,
            to_jsonb(OLD),
            NULL
        );

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;

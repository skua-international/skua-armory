-- Function to clean up expired sessions and their schemas
-- Should be called periodically (e.g., by a cron job or scheduled task)
CREATE OR REPLACE FUNCTION skua_master.cleanup_expired_sessions()
RETURNS INTEGER AS $$
DECLARE
    v_session RECORD;
    v_schema_name TEXT;
    v_count INTEGER := 0;
BEGIN
    -- Find all expired sessions (deadline passed and not active)
    FOR v_session IN
        SELECT session_id
        FROM skua_master.sessions
        WHERE deadline < NOW() AND is_active = FALSE
    LOOP
        -- Build schema name
        v_schema_name := 'skua_session_' || REPLACE(v_session.session_id::TEXT, '-', '_');

        -- Drop the session schema if it exists
        EXECUTE format('DROP SCHEMA IF EXISTS %I CASCADE', v_schema_name);

        -- Delete the session record
        DELETE FROM skua_master.sessions WHERE session_id = v_session.session_id;

        v_count := v_count + 1;
    END LOOP;

    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

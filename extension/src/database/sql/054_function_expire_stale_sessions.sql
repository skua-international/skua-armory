-- Function to mark sessions as inactive if heartbeat deadline passed
CREATE OR REPLACE FUNCTION skua_master.expire_stale_sessions()
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    UPDATE skua_master.sessions
    SET is_active = FALSE
    WHERE deadline < NOW() AND is_active = TRUE;
    
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

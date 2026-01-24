-- Trigger to update heartbeat on any session update
CREATE OR REPLACE TRIGGER trg_update_session_heartbeat
    BEFORE UPDATE ON skua_master.sessions
    FOR EACH ROW
    EXECUTE FUNCTION skua_master.update_heartbeat();

-- Function to automatically update session heartbeat and deadline
CREATE OR REPLACE FUNCTION skua_master.update_heartbeat()
RETURNS TRIGGER AS $$
BEGIN
    NEW.heartbeat = NOW();
    NEW.deadline = NOW() + INTERVAL '10 minutes';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

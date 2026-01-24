-- Index for finding active sessions
CREATE INDEX IF NOT EXISTS idx_sessions_is_active
    ON skua_master.sessions (is_active)
    WHERE is_active = TRUE;

-- Index for finding expired player data (for cleanup)
-- Replace ${session_id} with the actual session UUID (hyphens replaced with underscores)

CREATE INDEX IF NOT EXISTS idx_player_data_deadline
    ON "skua_session_${session_id}".player_data (deadline);

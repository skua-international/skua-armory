-- Session player data - stores ephemeral player data for reconnects
-- Replace ${session_id} with the actual session UUID (hyphens replaced with underscores)

CREATE TABLE IF NOT EXISTS "skua_session_${session_id}".player_data (
    steam_id        BIGINT PRIMARY KEY
                    REFERENCES skua_master.player_info(steam_id) ON DELETE CASCADE,
    world           TEXT NOT NULL,
    campaign_id     TEXT,  -- Optional, triggers promotion if set
    loadout         TEXT,
    position        JSONB,
    medical_data    JSONB,
    saved_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deadline        TIMESTAMPTZ NOT NULL DEFAULT NOW() + INTERVAL '30 minutes'
);

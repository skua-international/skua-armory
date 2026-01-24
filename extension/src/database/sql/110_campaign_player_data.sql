-- Campaign player data - stores persistent player data (world-agnostic)
-- Replace ${campaign_id} with the sanitized campaign identifier (hyphens replaced with underscores)

CREATE TABLE IF NOT EXISTS "skua_campaign_${campaign_id}".player_data (
    steam_id        BIGINT PRIMARY KEY
                    REFERENCES skua_master.player_info(steam_id) ON DELETE CASCADE,
    loadout         TEXT,
    medical_data    JSONB,
    last_updated    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

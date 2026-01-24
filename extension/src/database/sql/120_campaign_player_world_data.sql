-- Campaign player world data - stores player positions per world
-- Replace ${campaign_id} with the sanitized campaign identifier (hyphens replaced with underscores)

CREATE TABLE IF NOT EXISTS "skua_campaign_${campaign_id}".player_world_data (
    steam_id        BIGINT NOT NULL
                    REFERENCES skua_master.player_info(steam_id) ON DELETE CASCADE,
    world           TEXT NOT NULL,
    position        JSONB,
    last_updated    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (steam_id, world)
);

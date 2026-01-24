-- Index for finding all players on a specific world
-- Replace ${campaign_id} with the sanitized campaign identifier (hyphens replaced with underscores)

CREATE INDEX IF NOT EXISTS idx_player_world_data_world
    ON "skua_campaign_${campaign_id}".player_world_data (world);

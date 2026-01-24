-- Index for finding all objects on a specific world
-- Replace ${campaign_id} with the sanitized campaign identifier (hyphens replaced with underscores)

CREATE INDEX IF NOT EXISTS idx_world_data_world
    ON "skua_campaign_${campaign_id}".world_data (world);

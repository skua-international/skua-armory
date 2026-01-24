-- Index for finding sessions by campaign
CREATE INDEX IF NOT EXISTS idx_sessions_campaign_id
    ON skua_master.sessions (campaign_id)
    WHERE campaign_id IS NOT NULL;

-- Index for admin lookups
CREATE INDEX IF NOT EXISTS idx_player_info_is_admin
    ON skua_master.player_info (is_admin)
    WHERE is_admin = TRUE;

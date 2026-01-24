-- Index for banned lookups
CREATE INDEX IF NOT EXISTS idx_player_info_is_banned
    ON skua_master.player_info (is_banned)
    WHERE is_banned = TRUE;

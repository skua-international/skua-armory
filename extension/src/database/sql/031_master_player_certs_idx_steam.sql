-- Index for finding all certs a player has
CREATE INDEX IF NOT EXISTS idx_player_certs_steam_id
    ON skua_master.player_certs (steam_id);

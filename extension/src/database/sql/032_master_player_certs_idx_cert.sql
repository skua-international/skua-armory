-- Index for finding all players with a given cert
CREATE INDEX IF NOT EXISTS idx_player_certs_cert_id
    ON skua_master.player_certs (cert_id);

-- Index for finding all players with a given cert
CREATE INDEX IF NOT EXISTS idx_player_certs_cert_uuid
    ON skua_master.player_certs (cert_uuid);

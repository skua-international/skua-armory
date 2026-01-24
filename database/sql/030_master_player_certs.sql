-- Player certifications junction table
CREATE TABLE IF NOT EXISTS skua_master.player_certs (
    steam_id    BIGINT NOT NULL REFERENCES skua_master.player_info(steam_id) ON DELETE CASCADE,
    cert_uuid   UUID NOT NULL REFERENCES skua_master.certifications(uuid) ON DELETE CASCADE,

    PRIMARY KEY (steam_id, cert_uuid)
);

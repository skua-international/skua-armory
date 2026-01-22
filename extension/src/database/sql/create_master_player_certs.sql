CREATE TABLE IF NOT EXISTS skua_master.player_certs (
    steam_id    BIGINT NOT NULL,
    cert_uuid   UUID NOT NULL,

    PRIMARY KEY (steam_id, cert_uuid),

    CONSTRAINT fk_player
        FOREIGN KEY (steam_id)
        REFERENCES skua_master.player_info (steam_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_cert
        FOREIGN KEY (cert_uuid)
        REFERENCES skua_master.certifications (uuid)
        ON DELETE CASCADE
);
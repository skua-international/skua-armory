-- Postgres doesn't allow paramaters in identifiers, do it the bad way
CREATE TABLE IF NOT EXISTS "${schema}".player_data (
    steam_id        BIGINT NOT NULL,
    world           TEXT NOT NULL,

    PRIMARY KEY (steam_id,world),

    loadout         TEXT,
    position        TEXT,
    medical_data    JSONB,

    CONSTRAINT fk_player_info
        FOREIGN KEY (steam_id)
        REFERENCES skua_master.player_info (steam_id)
        ON DELETE CASCADE
);
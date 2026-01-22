CREATE TABLE IF NOT EXISTS skua_master.player_info (
    steam_id    BIGINT PRIMARY KEY,
    name        TEXT NOT NULL,
    first_seen  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_admin    BOOLEAN NOT NULL DEFAULT FALSE,
    is_banned   BOOLEAN NOT NULL DEFAULT FALSE,
    rank        SMALLINT NOT NULL DEFAULT 0,
    global_loadout JSONB NOT NULL DEFAULT '{}'
);
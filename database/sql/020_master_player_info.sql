-- Player info table - stores global player information that persists forever
CREATE TABLE IF NOT EXISTS skua_master.player_info (
    steam_id    BIGINT PRIMARY KEY,
    name        TEXT NOT NULL,
    first_seen  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_admin    BOOLEAN NOT NULL DEFAULT FALSE,
    is_banned   BOOLEAN NOT NULL DEFAULT FALSE,
    rank        SMALLINT NOT NULL DEFAULT 0 REFERENCES skua_master.ranks(id)
);

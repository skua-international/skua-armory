-- Ranks table - stores available ranks
CREATE TABLE IF NOT EXISTS skua_master.ranks (
    id              SMALLINT PRIMARY KEY,
    display_name    TEXT NOT NULL UNIQUE
);

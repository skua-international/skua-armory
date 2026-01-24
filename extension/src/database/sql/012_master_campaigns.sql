-- Campaigns table - stores campaign metadata
CREATE TABLE IF NOT EXISTS skua_master.campaigns (
    campaign_id         TEXT PRIMARY KEY,
    name                TEXT,
    description         TEXT,
    persist_position    BOOLEAN NOT NULL DEFAULT FALSE,
    persist_medical     BOOLEAN NOT NULL DEFAULT FALSE,
    persist_loadout     BOOLEAN NOT NULL DEFAULT FALSE,
    using_shop          BOOLEAN NOT NULL DEFAULT FALSE,
    persisting_world_data BOOLEAN NOT NULL DEFAULT FALSE
);

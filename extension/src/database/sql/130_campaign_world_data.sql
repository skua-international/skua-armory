-- Campaign world data - stores persistent world objects (vehicles, statics)
-- Replace ${campaign_id} with the sanitized campaign identifier (hyphens replaced with underscores)

CREATE TABLE IF NOT EXISTS "skua_campaign_${campaign_id}".world_data (
    uuid        UUID NOT NULL,
    world       TEXT NOT NULL,
    classname   TEXT NOT NULL,
    position    TEXT NOT NULL,

    PRIMARY KEY (uuid, world)
);

-- Postgres doesn't allow paramaters in identifiers, do it the bad way
CREATE TABLE IF NOT EXISTS "${schema}".world_data (
    uuid            UUID NOT NULL,
    world           TEXT NOT NULL,
    
    PRIMARY KEY (uuid, world),

    classname       TEXT NOT NULL,
    position        TEXT NOT NULL
);
-- Certifications table - stores available certifications
CREATE TABLE IF NOT EXISTS skua_master.certifications (
    -- id of the certification, e.g. "pilot", "parachute", etc.
    -- also the suffix of the event raise to set and revoke the player's certification, e.g. "skua_cert_pilot", "skua_cert_revoke_pilot"
    -- must be unique and not null
    id              TEXT PRIMARY KEY,
    display_name    TEXT NOT NULL UNIQUE, -- "Pretty" name of the certification, typically just the capitalized version of the id, e.g. "Pilot", "Parachute", etc.
    document        TEXT NOT NULL -- Link to the document describing the certification, e.g. "https://docs.skua.international/certs/pilot"
);

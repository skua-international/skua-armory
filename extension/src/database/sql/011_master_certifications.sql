-- Certifications table - stores available certifications
CREATE TABLE IF NOT EXISTS skua_master.certifications (
    uuid            UUID PRIMARY KEY,
    display_name    TEXT NOT NULL UNIQUE
);

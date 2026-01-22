-- Postgres doesn't allow paramaters in identifiers, do it the bad way
CREATE SCHEMA IF NOT EXISTS "${schema}";
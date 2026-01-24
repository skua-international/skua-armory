-- Template for creating a session schema
-- Replace ${session_id} with the actual session UUID (hyphens replaced with underscores)
-- Example: skua_session_550e8400_e29b_41d4_a716_446655440000

CREATE SCHEMA IF NOT EXISTS "skua_session_${session_id}";

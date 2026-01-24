-- Sessions table - stores session metadata
-- Sessions are 1:1 with worlds (one session per world)
CREATE TABLE IF NOT EXISTS skua_master.sessions (
    session_id  UUID PRIMARY KEY,
    world       TEXT NOT NULL,
    campaign_id TEXT REFERENCES skua_master.campaigns(campaign_id) ON DELETE SET NULL,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Heartbeat mechanism for detecting dead sessions
    -- Server should update periodically; deadline auto-extends on update
    heartbeat   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deadline    TIMESTAMPTZ NOT NULL DEFAULT NOW() + INTERVAL '10 minutes'
);

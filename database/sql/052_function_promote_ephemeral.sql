-- Function to promote ephemeral player data to campaign tables
-- Uses timestamp-based conflict resolution to prevent stale data from overwriting newer data
CREATE OR REPLACE FUNCTION skua_master.promote_ephemeral_player_data(
    p_campaign_id TEXT,
    p_world TEXT,
    p_steam_id BIGINT,
    p_loadout TEXT,
    p_position TEXT,
    p_medical_data JSONB,
    p_saved_at TIMESTAMPTZ
) RETURNS VOID AS $$
DECLARE
    v_schema_name TEXT;
BEGIN
    -- Exit early if no campaign
    IF p_campaign_id IS NULL THEN
        RETURN;
    END IF;

    -- Build schema name (replace hyphens with underscores)
    v_schema_name := 'skua_campaign_' || REPLACE(p_campaign_id, '-', '_');

    -- Promote player_data (loadout, medical_data) - world agnostic
    -- Only update if saved_at >= last_updated (or record doesn't exist)
    EXECUTE format(
        'INSERT INTO %I.player_data (steam_id, loadout, medical_data, last_updated)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (steam_id) DO UPDATE
         SET loadout = EXCLUDED.loadout,
             medical_data = EXCLUDED.medical_data,
             last_updated = EXCLUDED.last_updated
         WHERE %I.player_data.last_updated <= EXCLUDED.last_updated',
        v_schema_name, v_schema_name
    ) USING p_steam_id, p_loadout, p_medical_data, p_saved_at;

    -- Promote player_world_data (position) - world specific
    -- Only update if saved_at >= last_updated (or record doesn't exist)
    IF p_position IS NOT NULL THEN
        EXECUTE format(
            'INSERT INTO %I.player_world_data (steam_id, world, position, last_updated)
             VALUES ($1, $2, $3, $4)
             ON CONFLICT (steam_id, world) DO UPDATE
             SET position = EXCLUDED.position,
                 last_updated = EXCLUDED.last_updated
             WHERE %I.player_world_data.last_updated <= EXCLUDED.last_updated',
            v_schema_name, v_schema_name
        ) USING p_steam_id, p_world, p_position, p_saved_at;
    END IF;
END;
$$ LANGUAGE plpgsql;

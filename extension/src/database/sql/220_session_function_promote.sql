-- Trigger function to promote ephemeral data on insert/update
-- This is a template - create per session schema
-- Replace ${session_id} with the actual session UUID (hyphens replaced with underscores)

CREATE OR REPLACE FUNCTION "skua_session_${session_id}".promote_on_save()
RETURNS TRIGGER AS $$
BEGIN
    -- Call the master promotion function
    PERFORM skua_master.promote_ephemeral_player_data(
        NEW.campaign_id,
        NEW.world,
        NEW.steam_id,
        NEW.loadout,
        NEW.position,
        NEW.medical_data,
        NEW.saved_at
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger on insert/update to promote ephemeral data
-- Replace ${session_id} with the actual session UUID (hyphens replaced with underscores)

CREATE OR REPLACE TRIGGER trg_ephemeral_player_data_promote
    AFTER INSERT OR UPDATE ON "skua_session_${session_id}".player_data
    FOR EACH ROW
    EXECUTE FUNCTION "skua_session_${session_id}".promote_on_save();

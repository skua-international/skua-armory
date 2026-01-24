// src/extension_new/database/sql.rs
//
// SQL schema definitions embedded at compile time.
// Files are organized by schema type and numbered for dependency ordering.

// Master schema files (000-099)
pub mod master {
    pub const SCHEMA: &str = include_str!("sql/000_master_schema.sql");
    pub const RANKS: &str = include_str!("sql/010_master_ranks.sql");
    pub const CERTIFICATIONS: &str = include_str!("sql/011_master_certifications.sql");
    pub const CAMPAIGNS: &str = include_str!("sql/012_master_campaigns.sql");
    pub const PLAYER_INFO: &str = include_str!("sql/020_master_player_info.sql");
    pub const PLAYER_INFO_IDX_ADMIN: &str =
        include_str!("sql/021_master_player_info_idx_admin.sql");
    pub const PLAYER_INFO_IDX_BANNED: &str =
        include_str!("sql/022_master_player_info_idx_banned.sql");
    pub const PLAYER_CERTS: &str = include_str!("sql/030_master_player_certs.sql");
    pub const PLAYER_CERTS_IDX_STEAM: &str =
        include_str!("sql/031_master_player_certs_idx_steam.sql");
    pub const PLAYER_CERTS_IDX_CERT: &str =
        include_str!("sql/032_master_player_certs_idx_cert.sql");
    pub const SESSIONS: &str = include_str!("sql/040_master_sessions.sql");
    pub const SESSIONS_IDX_ACTIVE: &str = include_str!("sql/041_master_sessions_idx_active.sql");
    pub const SESSIONS_IDX_CAMPAIGN: &str =
        include_str!("sql/042_master_sessions_idx_campaign.sql");
    pub const FN_UPDATE_HEARTBEAT: &str = include_str!("sql/050_function_update_heartbeat.sql");
    pub const TRIGGER_UPDATE_HEARTBEAT: &str = include_str!("sql/051_trigger_update_heartbeat.sql");
    pub const FN_PROMOTE_EPHEMERAL: &str = include_str!("sql/052_function_promote_ephemeral.sql");
    pub const FN_CLEANUP_EXPIRED: &str =
        include_str!("sql/053_function_cleanup_expired_sessions.sql");
    pub const FN_EXPIRE_STALE: &str = include_str!("sql/054_function_expire_stale_sessions.sql");
}

// Campaign schema templates (100-199)
pub mod campaign {
    pub const SCHEMA: &str = include_str!("sql/100_campaign_schema.sql");
    pub const PLAYER_DATA: &str = include_str!("sql/110_campaign_player_data.sql");
    pub const PLAYER_WORLD_DATA: &str = include_str!("sql/120_campaign_player_world_data.sql");
    pub const PLAYER_WORLD_DATA_IDX: &str =
        include_str!("sql/121_campaign_player_world_data_idx.sql");
    pub const WORLD_DATA: &str = include_str!("sql/130_campaign_world_data.sql");
    pub const WORLD_DATA_IDX: &str = include_str!("sql/131_campaign_world_data_idx.sql");
}

// Session schema templates (200-299)
pub mod session {
    pub const SCHEMA: &str = include_str!("sql/200_session_schema.sql");
    pub const PLAYER_DATA: &str = include_str!("sql/210_session_player_data.sql");
    pub const PLAYER_DATA_IDX: &str = include_str!("sql/211_session_player_data_idx.sql");
    pub const FN_PROMOTE: &str = include_str!("sql/220_session_function_promote.sql");
    pub const TRIGGER_PROMOTE: &str = include_str!("sql/221_session_trigger_promote.sql");
}

// src/extension/database/schema.rs
//
// Database schema bootstrap operations.
// Handles creation of master, campaign, and session schemas.

use arma_rs::Context;
use tokio_postgres::Client;
use tracing::{info, instrument};
use uuid::Uuid;

use super::heartbeat;
use super::pool::{get_client, get_db};
use super::sql::{campaign, master, session};
use super::state::DatabaseState;
use crate::core::{RUNTIME, SESSION_ID};
use crate::error::{QueryResult, QueryState, transient_error};

use regex::Regex;

/// Sanitizes a key for use as a schema name.
/// Returns error if the key doesn't match the required pattern.
pub fn sanitize_key(key: &str) -> Result<String, &'static str> {
    let key = key.replace('-', "_").replace(' ', "_").to_lowercase();

    let re = Regex::new(r"^[a-z0-9_]{3,49}$").unwrap();
    if !re.is_match(&key) {
        return Err("invalid key pattern");
    }

    Ok(key)
}

/// Converts a UUID to schema key format (hyphens to underscores).
fn uuid_to_schema_key(uuid: &Uuid) -> String {
    uuid.to_string().replace('-', "_")
}

/// Bootstraps the master schema and global tables.
#[instrument(level = "debug", name = "bootstrap_master")]
async fn bootstrap_master(client: &Client) -> Result<(), QueryResult> {
    // Layer 0: Create master schema
    if let Err(e) = client.execute(master::SCHEMA, &[]).await {
        return Err(transient_error("Failed to create master schema", e));
    }

    // Layer 1: Independent base tables
    let layer1 = [
        (master::RANKS, "ranks table"),
        (master::CERTIFICATIONS, "certifications table"),
        (master::CAMPAIGNS, "campaigns table"),
    ];

    for (sql, desc) in layer1 {
        if let Err(e) = client.execute(sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
    }

    // Layer 2: Tables with dependencies
    if let Err(e) = client.execute(master::PLAYER_INFO, &[]).await {
        return Err(transient_error("Failed to create player_info table", e));
    }

    // Layer 2b: Indexes for player_info
    for (sql, desc) in [
        (master::PLAYER_INFO_IDX_ADMIN, "admin index"),
        (master::PLAYER_INFO_IDX_BANNED, "banned index"),
    ] {
        if let Err(e) = client.execute(sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
    }

    // Layer 3: Tables depending on player_info
    for (sql, desc) in [
        (master::PLAYER_CERTS, "player_certs table"),
        (master::SESSIONS, "sessions table"),
    ] {
        if let Err(e) = client.execute(sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
    }

    // Layer 3b: Indexes for layer 3 tables
    for (sql, desc) in [
        (master::PLAYER_CERTS_IDX_STEAM, "player_certs steam index"),
        (master::PLAYER_CERTS_IDX_CERT, "player_certs cert index"),
        (master::SESSIONS_IDX_ACTIVE, "sessions active index"),
        (master::SESSIONS_IDX_CAMPAIGN, "sessions campaign index"),
    ] {
        if let Err(e) = client.execute(sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
    }

    // Layer 4: Functions
    for (sql, desc) in [
        (master::FN_UPDATE_HEARTBEAT, "update_heartbeat function"),
        (master::FN_PROMOTE_EPHEMERAL, "promote_ephemeral function"),
        (master::FN_CLEANUP_EXPIRED, "cleanup_expired function"),
        (master::FN_EXPIRE_STALE, "expire_stale function"),
    ] {
        if let Err(e) = client.execute(sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
    }

    // Layer 5: Triggers
    if let Err(e) = client.execute(master::TRIGGER_UPDATE_HEARTBEAT, &[]).await {
        return Err(transient_error("Failed to create heartbeat trigger", e));
    }

    info!("master schema bootstrapped");
    Ok(())
}

/// Bootstraps a campaign schema.
#[instrument(level = "debug", name = "bootstrap_campaign", skip(client))]
async fn bootstrap_campaign(client: &Client, campaign_id: &str) -> Result<(), QueryResult> {
    let schema_key = campaign_id.replace('-', "_");

    // Layer 0: Schema
    let sql = campaign::SCHEMA.replace("${campaign_id}", &schema_key);
    if let Err(e) = client.execute(&sql, &[]).await {
        return Err(transient_error("Failed to create campaign schema", e));
    }

    // Layer 1: Tables
    for (template, desc) in [
        (campaign::PLAYER_DATA, "player_data table"),
        (campaign::PLAYER_WORLD_DATA, "player_world_data table"),
        (campaign::WORLD_DATA, "world_data table"),
    ] {
        let sql = template.replace("${campaign_id}", &schema_key);
        if let Err(e) = client.execute(&sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
    }

    // Layer 2: Indexes
    for (template, desc) in [
        (campaign::PLAYER_WORLD_DATA_IDX, "player_world_data index"),
        (campaign::WORLD_DATA_IDX, "world_data index"),
    ] {
        let sql = template.replace("${campaign_id}", &schema_key);
        if let Err(e) = client.execute(&sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
    }

    // Register campaign
    let register_sql = r#"
        INSERT INTO skua_master.campaigns (campaign_id)
        VALUES ($1)
        ON CONFLICT (campaign_id) DO NOTHING
    "#;
    let campaign_id_formatted = format!("skua_campaign_{}", schema_key);
    if let Err(e) = client
        .execute(register_sql, &[&campaign_id_formatted])
        .await
    {
        return Err(transient_error("Failed to register campaign", e));
    }

    info!(campaign_id = %campaign_id, "campaign schema bootstrapped");
    Ok(())
}

/// Bootstraps a session schema.
#[instrument(level = "debug", name = "bootstrap_session", skip(client))]
async fn bootstrap_session(client: &Client, session_id: &Uuid) -> Result<(), QueryResult> {
    let schema_key = uuid_to_schema_key(session_id);

    // Layer 0: Schema
    let sql = session::SCHEMA.replace("${session_id}", &schema_key);
    if let Err(e) = client.execute(&sql, &[]).await {
        return Err(transient_error("Failed to create session schema", e));
    }

    // Layer 1: Tables
    let sql = session::PLAYER_DATA.replace("${session_id}", &schema_key);
    if let Err(e) = client.execute(&sql, &[]).await {
        return Err(transient_error("Failed to create session player_data", e));
    }

    // Layer 1b: Index
    let sql = session::PLAYER_DATA_IDX.replace("${session_id}", &schema_key);
    if let Err(e) = client.execute(&sql, &[]).await {
        return Err(transient_error("Failed to create session index", e));
    }

    // Layer 2: Function
    let sql = session::FN_PROMOTE.replace("${session_id}", &schema_key);
    if let Err(e) = client.execute(&sql, &[]).await {
        return Err(transient_error("Failed to create promote function", e));
    }

    // Layer 3: Trigger
    let sql = session::TRIGGER_PROMOTE.replace("${session_id}", &schema_key);
    if let Err(e) = client.execute(&sql, &[]).await {
        return Err(transient_error("Failed to create promote trigger", e));
    }

    info!(session_id = %session_id, "session schema bootstrapped");
    Ok(())
}

/// Full database bootstrap: master + optional campaign + session.
#[instrument(level = "debug", skip_all, fields(session_id = %session_id, campaign_id = ?campaign_id, world = %world))]
async fn do_bootstrap(
    session_id: &Uuid,
    campaign_id: Option<String>,
    world: String,
) -> QueryResult {
    let db = match get_db().await {
        Ok(db) => db,
        Err(e) => return transient_error("Failed to get database handle", e),
    };

    let client = match db.get_conn().await {
        Ok(c) => c,
        Err(e) => return transient_error("Failed to get connection", e),
    };

    // Phase 1: Master schema
    if let Err(result) = bootstrap_master(&client).await {
        return result;
    }

    // Phase 2: Campaign schema (optional)
    if let Some(ref cid) = campaign_id {
        if let Err(result) = bootstrap_campaign(&client, cid).await {
            return result;
        }
    }

    // Phase 3: Session schema
    if let Err(result) = bootstrap_session(&client, session_id).await {
        return result;
    }

    // Phase 4: Register session
    let register_sql = r#"
        INSERT INTO skua_master.sessions (session_id, world, campaign_id, is_active)
        VALUES ($1, $2, $3, TRUE)
        ON CONFLICT (session_id) DO UPDATE
        SET is_active = TRUE,
            heartbeat = NOW(),
            deadline = NOW() + INTERVAL '10 minutes'
    "#;

    let campaign_schema = campaign_id.map(|cid| format!("skua_campaign_{}", cid.replace('-', "_")));
    if let Err(e) = client
        .execute(register_sql, &[session_id, &world, &campaign_schema])
        .await
    {
        return transient_error("Failed to register session", e);
    }

    db.set_state(DatabaseState::ConnectedInit);

    // Start background heartbeat task
    heartbeat::start();

    info!(
        session_id = %session_id,
        campaign_id = ?campaign_schema,
        world = %world,
        "bootstrap complete"
    );

    QueryResult::done()
}

/// Entry point for bootstrap (Arma command).
pub fn bootstrap(ctx: Context, campaign_id: String, terrain: String) -> QueryState {
    let session_id = *SESSION_ID;
    let campaign = if campaign_id.is_empty() {
        None
    } else {
        match sanitize_key(&campaign_id) {
            Ok(sanitized) => Some(sanitized),
            Err(_) => return QueryState::InvalidArgument,
        }
    };

    RUNTIME.spawn(async move {
        let result = do_bootstrap(&session_id, campaign, terrain).await;
        let _ = ctx.callback_data("skua:database", "bootstrap", result);
    });

    QueryState::Processing
}

/// End session command.
pub fn end_session(ctx: Context) -> QueryState {
    let session_uuid = *SESSION_ID;

    // Stop the heartbeat task
    heartbeat::stop();

    RUNTIME.spawn(async move {
        let client = match get_client().await {
            Ok(c) => c,
            Err(e) => {
                let result = transient_error("Failed to get client", e);
                let _ = ctx.callback_data("skua:database", "end_session", result);
                return;
            }
        };

        let sql = "UPDATE skua_master.sessions SET is_active = FALSE WHERE session_id = $1";
        if let Err(e) = client.execute(sql, &[&session_uuid]).await {
            let result = transient_error("Failed to end session", e);
            let _ = ctx.callback_data("skua:database", "end_session", result);
            return;
        }

        info!(session_id = %session_uuid, "session ended");
        let _ = ctx.callback_data("skua:database", "end_session", QueryResult::done());
    });

    QueryState::Processing
}

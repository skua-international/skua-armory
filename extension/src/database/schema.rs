// src/extension/database/schema.rs
//
// Database schema bootstrap operations.
// Handles creation of master and campaign schemas.

use arma_rs::Context;
use tokio_postgres::Client;
use tracing::{info, instrument};

use super::pool::get_db;
use super::sql::{campaign, master};
use super::state::DatabaseState;
use crate::core::RUNTIME;
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
    if let Err(e) = client.execute(master::PLAYER_CERTS, &[]).await {
        return Err(transient_error("Failed to create player_certs table", e));
    }

    // Layer 3b: Indexes for player_certs
    for (sql, desc) in [
        (master::PLAYER_CERTS_IDX_STEAM, "player_certs steam index"),
        (master::PLAYER_CERTS_IDX_CERT, "player_certs cert index"),
    ] {
        if let Err(e) = client.execute(sql, &[]).await {
            return Err(transient_error(&format!("Failed to create {}", desc), e));
        }
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

/// Full database bootstrap: master + optional campaign.
#[instrument(level = "debug", skip_all, fields(campaign_id = ?campaign_id))]
async fn do_bootstrap(campaign_id: Option<String>) -> QueryResult {
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

    db.set_state(DatabaseState::ConnectedInit);

    info!(campaign_id = ?campaign_id, "bootstrap complete");

    QueryResult::done()
}

/// Entry point for bootstrap (Arma command).
pub fn bootstrap(ctx: Context, campaign_id: String) -> QueryState {
    let campaign = if campaign_id.is_empty() {
        None
    } else {
        match sanitize_key(&campaign_id) {
            Ok(sanitized) => Some(sanitized),
            Err(_) => return QueryState::InvalidArgument,
        }
    };

    RUNTIME.spawn(async move {
        let result = do_bootstrap(campaign).await;
        let _ = ctx.callback_data("skua:database", "bootstrap", result);
    });

    QueryState::Processing
}

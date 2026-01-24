// src/extension_new/persistence/commands.rs
//
// Arma-callable persistence commands.

use arma_rs::{Context, Group};
use tracing::{error, info, instrument};

use super::types::{ObjectData, ObjectPosition, PersistedObject, PlayerData, UnitData};
use crate::core::{ContextProvider, RUNTIME};
use crate::database::{DatabaseState, get_client, get_state};
use crate::domain::{CampaignId, SessionId};
use crate::error::{QueryResult, QueryState, transient_error};

/// Command group for persistence operations.
pub fn group() -> Group {
    Group::new().command("save", save::<Context>)
}

/// Entry point for all persistence save operations.
pub fn save<T: ContextProvider + Send + Sync + 'static>(
    ctx: T,
    serialized_object: PersistedObject,
    campaign_id: CampaignId,
    session_id: SessionId,
) -> QueryResult {
    // Check database is bootstrapped
    let state = get_state();
    if state != DatabaseState::ConnectedInit {
        error!(?state, "database not bootstrapped");
        return QueryResult::new(QueryState::TransientFailure);
    }

    match serialized_object {
        PersistedObject::Unit { .. } => {
            // TODO: Implement unit persistence
            unimplemented!("Unit persistence not yet implemented");
        }
        PersistedObject::Player {
            object,
            unit,
            player,
        } => {
            save_player(ctx, campaign_id, session_id, object, unit, player);
        }
        PersistedObject::Container { .. } => {
            unimplemented!("Container persistence not yet implemented");
        }
        PersistedObject::Vehicle { .. } => {
            unimplemented!("Vehicle persistence not yet implemented");
        }
        PersistedObject::Static { .. } => {
            unimplemented!("Static persistence not yet implemented");
        }
    }

    QueryResult::processing()
}

/// Saves player data to the session schema.
///
/// This function saves the player's current state to the ephemeral session storage.
/// If the session is associated with a campaign, the database trigger will automatically
/// promote the data to campaign storage using timestamp-based conflict resolution.
///
/// # Requirements
/// - Database must be bootstrapped (state = ConnectedInit)
/// - Session schema must exist
///
/// # Arguments
/// - `ctx` - Context provider for callbacks
/// - `campaign_id` - Campaign ID (may be nil UUID if not in a campaign)
/// - `session_id` - Current session UUID
/// - `object` - Base object data (position, world, etc.)
/// - `unit` - Unit-specific data (loadout, medical state)
/// - `player` - Player-specific data (steam_id, rank)
fn save_player<T: ContextProvider + Send + Sync + 'static>(
    ctx: T,
    campaign_id: CampaignId,
    session_id: SessionId,
    object: ObjectData,
    unit: UnitData,
    player: PlayerData,
) {
    RUNTIME.spawn(async move {
        let result = do_save_player(campaign_id, session_id, object, unit, player).await;
        let _ = ctx.callback_data("skua:persistence", "save_player", result);
    });
}

/// Internal async implementation of player save.
#[instrument(
    level = "debug",
    name = "save_player",
    skip(unit),
    fields(steam_id = %player.steam_id, world = %object.last_world)
)]
async fn do_save_player(
    campaign_id: CampaignId,
    session_id: SessionId,
    object: ObjectData,
    unit: UnitData,
    player: PlayerData,
) -> QueryResult {
    // Get database client
    let client = match get_client().await {
        Ok(c) => c,
        Err(e) => return transient_error("Failed to get database client", e),
    };

    // Build schema name from session UUID
    let table_name = format!("skua_session_{}.player_data", session_id.to_schema_key());

    // Determine campaign_id for promotion (nil UUID means no campaign)
    let campaign_schema: Option<String> = if campaign_id.is_nil() {
        None
    } else {
        Some(format!("skua_campaign_{}", campaign_id.to_schema_key()))
    };

    // Serialize data
    let serialized_position = serde_json::to_string(&ObjectPosition {
        position: object.position,
        orientation: object.orientation,
        direction: object.direction,
    });

    let position = match serialized_position {
        Ok(pos) => pos,
        Err(e) => return transient_error("Failed to serialize object position", e),
    };

    // Serialize loadout to string
    let loadout_str = serde_json::to_string(&unit.loadout).unwrap_or_else(|_| "[]".to_string());

    // Medical data is already JsonValue
    let medical_data = unit.medical_state.clone();

    // Upsert into session player_data
    // The table schema is:
    // steam_id, world, campaign_id, loadout, position, medical_data, saved_at, deadline
    let sql = format!(
        r#"
        INSERT INTO {} (steam_id, world, campaign_id, loadout, position, medical_data, saved_at, deadline)
        VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW() + INTERVAL '30 minutes')
        ON CONFLICT (steam_id) DO UPDATE
        SET world = EXCLUDED.world,
            campaign_id = EXCLUDED.campaign_id,
            loadout = EXCLUDED.loadout,
            position = EXCLUDED.position,
            medical_data = EXCLUDED.medical_data,
            saved_at = NOW(),
            deadline = NOW() + INTERVAL '30 minutes'
        "#,
        table_name
    );

    if let Err(e) = client
        .execute(
            &sql,
            &[
                &player.steam_id,
                &object.last_world,
                &campaign_schema,
                &loadout_str,
                &position,
                &medical_data,
            ],
        )
        .await
    {
        return transient_error("Failed to save player data", e);
    }

    info!(
        steam_id = %player.steam_id,
        world = %object.last_world,
        campaign = ?campaign_schema,
        "player data saved"
    );

    QueryResult::done()
}

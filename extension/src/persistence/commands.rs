// src/extension/persistence/commands.rs
//
// Arma-callable persistence commands.

use arma_rs::{Context, Group};
use tracing::{error, info, instrument, warn};

use super::types::{ObjectData, ObjectPosition, PersistedObject, PlayerData, UnitData};
use crate::core::RUNTIME;
use crate::database::{DatabaseState, get_client, get_state};
use crate::domain::CampaignId;
use crate::error::{QueryResult, QueryState, transient_error};

/// Command group for persistence operations.
pub fn group() -> Group {
    Group::new().command("save", save)
}

/// Entry point for all persistence save operations.
pub fn save(
    ctx: Context,
    serialized_object: PersistedObject,
    campaign_id: CampaignId,
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
            save_player(ctx, campaign_id, object, unit, player);
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

/// Saves player data to campaign storage.
///
/// This function saves the player's current state directly to campaign storage.
/// If no campaign is set, the save is skipped.
///
/// # Requirements
/// - Database must be bootstrapped (state = ConnectedInit)
/// - Campaign schema must exist
///
/// # Arguments
/// - `ctx` - Context provider for callbacks
/// - `campaign_id` - Campaign ID (may be nil UUID if not in a campaign)
/// - `object` - Base object data (position, world, etc.)
/// - `unit` - Unit-specific data (loadout, medical state)
/// - `player` - Player-specific data (steam_id, rank)
fn save_player(
    ctx: Context,
    campaign_id: CampaignId,
    object: ObjectData,
    unit: UnitData,
    player: PlayerData,
) {
    RUNTIME.spawn(async move {
        let result = do_save_player(campaign_id, object, unit, player).await;
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
    object: ObjectData,
    unit: UnitData,
    player: PlayerData,
) -> QueryResult {
    // Skip if no campaign is set
    if campaign_id.is_nil() {
        warn!(steam_id = %player.steam_id, "no campaign set, skipping save");
        return QueryResult::done();
    }

    // Get database client
    let client = match get_client().await {
        Ok(c) => c,
        Err(e) => return transient_error("Failed to get database client", e),
    };

    let schema_key = campaign_id.to_schema_key();

    // Serialize position
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

    // Upsert into campaign player_data (loadout, medical_data)
    let player_data_sql = format!(
        r#"
        INSERT INTO skua_campaign_{}.player_data (steam_id, loadout, medical_data, last_updated)
        VALUES ($1, $2, $3, NOW())
        ON CONFLICT (steam_id) DO UPDATE
        SET loadout = EXCLUDED.loadout,
            medical_data = EXCLUDED.medical_data,
            last_updated = NOW()
        "#,
        schema_key
    );

    if let Err(e) = client
        .execute(&player_data_sql, &[&player.steam_id, &loadout_str, &medical_data])
        .await
    {
        return transient_error("Failed to save player data", e);
    }

    // Upsert into campaign player_world_data (position)
    let world_data_sql = format!(
        r#"
        INSERT INTO skua_campaign_{}.player_world_data (steam_id, world, position, last_updated)
        VALUES ($1, $2, $3, NOW())
        ON CONFLICT (steam_id, world) DO UPDATE
        SET position = EXCLUDED.position,
            last_updated = NOW()
        "#,
        schema_key
    );

    if let Err(e) = client
        .execute(&world_data_sql, &[&player.steam_id, &object.last_world, &position])
        .await
    {
        return transient_error("Failed to save player world data", e);
    }

    info!(
        steam_id = %player.steam_id,
        world = %object.last_world,
        campaign = %schema_key,
        "player data saved"
    );

    QueryResult::done()
}

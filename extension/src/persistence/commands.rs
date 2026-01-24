// src/extension_new/persistence/commands.rs
//
// Arma-callable persistence commands.

use arma_rs::{Context, Group};
use tracing::info;

use super::types::{ObjectData, PersistedObject, PlayerData, UnitData};
use crate::core::RUNTIME;
use crate::domain::{CampaignId, SessionId};
use crate::error::QueryResult;

/// Command group for persistence operations.
pub fn group() -> Group {
    Group::new().command("save", save)
}

/// Entry point for all persistence save operations.
pub fn save(
    ctx: Context,
    serialized_object: PersistedObject,
    campaign_id: CampaignId,
    session_id: SessionId,
) -> QueryResult {
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

fn save_player(
    ctx: Context,
    campaign_id: CampaignId,
    session_id: SessionId,
    object: ObjectData,
    unit: UnitData,
    player: PlayerData,
) {
    RUNTIME.spawn(async move {
        info!(uuid = %object.uuid, steam_id = %player.steam_id, "saving player");

        // TODO: Implement actual database save
        let _ = (ctx, campaign_id, session_id, object, unit, player);
    });
}

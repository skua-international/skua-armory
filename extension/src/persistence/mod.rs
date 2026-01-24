// src/extension_new/persistence/mod.rs
//
// Persistence layer for game state.
// Handles saving and loading of players, vehicles, containers, and world objects.

mod commands;
mod types;

pub use commands::group;
pub use types::{ObjectData, PersistedObject, PlayerData, UnitData, VehicleData};

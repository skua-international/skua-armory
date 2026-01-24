// src/extension_new/database/mod.rs
//
// Database connectivity and schema management.
//
// This module provides:
// - Connection pool management (`pool`)
// - Schema bootstrap operations (`schema`)
// - Arma-callable commands (`commands`)

mod commands;
mod heartbeat;
mod pool;
mod schema;
mod sql;
mod state;

#[cfg(test)]
mod tests;

pub use commands::group;
pub use pool::{Database, get_client, get_db, get_state};
pub use state::DatabaseState;

#[cfg(test)]
pub use schema::{bootstrap_campaign, bootstrap_master, bootstrap_session};

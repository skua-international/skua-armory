// src/extension_new/database/mod.rs
//
// Database connectivity and schema management.
//
// This module provides:
// - Connection pool management (`pool`)
// - Schema bootstrap operations (`schema`)
// - Arma-callable commands (`commands`)

mod commands;
mod pool;
mod schema;
mod sql;
mod state;

#[cfg(test)]
mod tests;

pub use commands::group;
pub use pool::{Database, get_client, get_db};
pub use state::DatabaseState;

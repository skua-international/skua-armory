// src/extension/database/commands.rs
//
// Arma-callable database commands.

use arma_rs::Group;

use super::pool::get_database_state;
use super::schema::{bootstrap, end_session};

/// Command group for database operations.
pub fn group() -> Group {
    Group::new()
        .command("bootstrap", bootstrap)
        .command("state", get_database_state)
        .command("end_session", end_session)
}

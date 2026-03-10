// src/extension/lib.rs
//
// Arma 3 Skua extension entry point.
//
// This extension provides database persistence for Arma 3 missions,
// including player data, vehicles, and world state.

use arma_rs::{Extension, arma};
use std::collections::HashMap;
use uuid::Uuid;

// Core infrastructure
pub mod core;
pub use core::RUNTIME;

// Error handling
pub mod error;
pub use error::{DbError, QueryError, QueryResult, QueryState};

// Domain types
pub mod domain;
pub use domain::{CampaignId, PlayerId};

// Feature modules
pub mod certification;
pub mod database;
pub mod logging;
pub mod persistence;

/// Extension entry point.
#[arma]
fn init() -> Extension {
    let ext = Extension::build()
        // Top-level commands
        .command("uuid", Uuid::now_v7)
        .command("diagnostics", diagnostics)
        // Command groups
        .group("logger", logging::group())
        .group("database", database::group())
        .group("persistence", persistence::group())
        .finish();

    // Initialize logging with extension context
    logging::init(ext.context());

    ext
}

/// Get diagnostics information about the extension runtime.
fn diagnostics() -> HashMap<&'static str, String> {
    use std::collections::HashMap;

    let mut output: HashMap<&str, String> = HashMap::new();
    output.insert("runtime", format!("Tokio Runtime: {:?}", RUNTIME.handle()));
    output.insert("database_state", format!("{:?}", database::get_state()));

    output
}

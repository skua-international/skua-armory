// src/extension_new/logging/mod.rs
//
// Structured logging infrastructure.
// Provides a tracing layer that forwards logs to Arma via callbacks.

mod commands;
mod layer;

pub use commands::group;
pub use layer::init;

use std::sync::RwLock;
use tracing::Level;

/// Global log level filter (default: INFO).
/// Protected by RwLock for dynamic level changes.
pub(crate) static LOG_LEVEL: RwLock<Level> = RwLock::new(Level::INFO);

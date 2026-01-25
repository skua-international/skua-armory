// src/extension/core/session.rs
//
// Session management for the current Arma session.
// Each extension load creates a new unique session.

use std::sync::LazyLock;
use uuid::Uuid;

/// Unique identifier for the current session.
///
/// Generated once when the extension is first loaded and remains constant
/// for the lifetime of the process. Uses UUIDv7 for time-ordered uniqueness.
pub static SESSION_ID: LazyLock<Uuid> = LazyLock::new(Uuid::now_v7);

// src/extension/core/mod.rs
//
// Core infrastructure shared across all modules.
// This includes the global async runtime and session management.

mod runtime;
mod session;

pub use runtime::RUNTIME;
pub use session::SESSION_ID;

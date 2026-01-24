// src/extension_new/core/mod.rs
//
// Core infrastructure shared across all modules.
// This includes the global async runtime and session management.

mod context;
mod runtime;
mod session;

pub use context::CallbackError;
pub use context::ContextProvider;
pub use runtime::RUNTIME;
pub use session::SESSION_ID;

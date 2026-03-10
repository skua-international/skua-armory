// src/extension/core/mod.rs
//
// Core infrastructure shared across all modules.
// This includes the global async runtime.

mod runtime;

pub use runtime::RUNTIME;

// src/extension_new/core/runtime.rs
//
// Global Tokio runtime for async operations.
// All async work should be spawned onto this runtime.

use std::sync::LazyLock;

/// Global Tokio runtime for spawning async tasks.
///
/// # Usage
/// ```rust
/// use crate::core::RUNTIME;
///
/// RUNTIME.spawn(async {
///     // async work here
/// });
/// ```
///
/// # Note
/// This runtime is initialized lazily on first access. It uses a multi-threaded
/// executor with all features enabled.
pub static RUNTIME: LazyLock<tokio::runtime::Runtime> = LazyLock::new(|| {
    tokio::runtime::Builder::new_multi_thread()
        .enable_all()
        .build()
        .expect("failed to initialize tokio runtime")
});

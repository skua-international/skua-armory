// src/extension/error/mod.rs
//
// Centralized error handling for the extension.
// Provides unified error types and utilities for converting errors
// into Arma-compatible responses.

mod db;
mod query;

pub use db::DbError;
pub use query::{QueryError, QueryResult, QueryState};

use std::error::Error;
use tracing::error;

/// Creates a transient error result with logging.
///
/// Use this for recoverable errors that should be reported back to Arma.
/// The error is logged with file/line information and wrapped in a QueryResult.
///
/// # Example
/// ```ignore
/// use skua::error::transient_error;
/// use skua::QueryResult;
///
/// async fn do_work() -> QueryResult {
///     match some_operation().await {
///         Ok(result) => QueryResult::done(),
///         Err(e) => transient_error("Operation failed", e),
///     }
/// }
/// ```
#[track_caller]
pub fn transient_error<E>(message: &str, error: E) -> QueryResult
where
    E: Error,
{
    let loc = std::panic::Location::caller();

    error!(
        error = %error,
        file = loc.file(),
        line = loc.line(),
        column = loc.column(),
        "{}",
        message
    );

    QueryResult {
        state: QueryState::TransientFailure,
        error: Some(QueryError {
            code: "UNAVAILABLE".to_string(),
            message: format!("{}: {}", message, error),
            location: format!("{}:{}", loc.file(), loc.line()),
        }),
    }
}

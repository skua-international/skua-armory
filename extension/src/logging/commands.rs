// src/extension/logging/commands.rs
//
// Arma-callable commands for log level management.

use arma_rs::Group;
use tracing::Level;

use super::LOG_LEVEL;

/// Set the log level dynamically.
///
/// Valid levels: "ERROR", "WARN", "INFO", "DEBUG", "TRACE"
pub fn set_level(level: String) -> String {
    let new_level = match level.to_uppercase().as_str() {
        "ERROR" => Level::ERROR,
        "WARN" => Level::WARN,
        "INFO" => Level::INFO,
        "DEBUG" => Level::DEBUG,
        "TRACE" => Level::TRACE,
        _ => return String::new(),
    };

    if let Ok(mut current) = LOG_LEVEL.write() {
        *current = new_level;
        get_level()
    } else {
        String::new()
    }
}

/// Get the current log level as a string.
pub fn get_level() -> String {
    LOG_LEVEL
        .read()
        .map(|level| level.to_string())
        .unwrap_or_else(|_| "INFO".to_string())
}

/// Command group for logger operations.
pub fn group() -> Group {
    Group::new()
        .command("set_level", set_level)
        .command("get_level", get_level)
}

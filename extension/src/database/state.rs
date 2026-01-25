// src/extension/database/state.rs
//
// Database connection state tracking.

use arma_rs::{FromArma, IntoArma};
use std::{
    fmt::Display,
    sync::atomic::{AtomicU8, Ordering},
};

/// Current state of the database connection.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum DatabaseState {
    /// Waiting for initial connection
    AwaitConnect = 0,
    /// Connected and initialized
    ConnectedInit = 1,
    /// Connected but awaiting schema initialization
    ConnectedAwaitInit = 2,
    /// Connection failed
    Failed = 3,
}

impl IntoArma for DatabaseState {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::Number((*self as u8).into())
    }
}

impl Display for DatabaseState {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let s = match self {
            DatabaseState::AwaitConnect => "AwaitConnect",
            DatabaseState::ConnectedInit => "ConnectedInit",
            DatabaseState::ConnectedAwaitInit => "ConnectedAwaitInit",
            DatabaseState::Failed => "Failed",
        };
        write!(f, "{}", s)
    }
}

impl FromArma for DatabaseState {
    fn from_arma(s: String) -> Result<Self, arma_rs::FromArmaError> {
        let v: u8 = s
            .parse()
            .map_err(|_| arma_rs::FromArmaError::Custom("Invalid number".into()))?;
        match v {
            0 => Ok(DatabaseState::AwaitConnect),
            1 => Ok(DatabaseState::ConnectedInit),
            2 => Ok(DatabaseState::ConnectedAwaitInit),
            3 => Ok(DatabaseState::Failed),
            _ => Err(arma_rs::FromArmaError::Custom("Invalid enum value".into())),
        }
    }
}

/// Thread-safe atomic wrapper for DatabaseState.
#[derive(Debug)]
pub struct AtomicDatabaseState {
    inner: AtomicU8,
}

impl AtomicDatabaseState {
    pub fn new(state: DatabaseState) -> Self {
        Self {
            inner: AtomicU8::new(state as u8),
        }
    }

    pub fn load(&self) -> DatabaseState {
        match self.inner.load(Ordering::Relaxed) {
            0 => DatabaseState::AwaitConnect,
            1 => DatabaseState::ConnectedInit,
            2 => DatabaseState::ConnectedAwaitInit,
            _ => DatabaseState::Failed,
        }
    }

    pub fn store(&self, state: DatabaseState) {
        self.inner.store(state as u8, Ordering::Relaxed);
    }
}

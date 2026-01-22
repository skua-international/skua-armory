// database/types.rs

use arma_rs::IntoArma;
use std::collections::HashMap;
use std::sync::atomic::{AtomicU8, Ordering};

/* ============================
 * Database State
 * ============================ */

#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum DatabaseState {
    AWAIT_CONNECT,
    CONNECTED_INIT,
    CONNECTED_AWAIT_INIT,
    FAILED,
}

/* ============================
 * Atomic wrapper
 * ============================ */

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
            x if x == DatabaseState::AWAIT_CONNECT as u8 => DatabaseState::AWAIT_CONNECT,
            x if x == DatabaseState::CONNECTED_INIT as u8 => DatabaseState::CONNECTED_INIT,
            x if x == DatabaseState::CONNECTED_AWAIT_INIT as u8 => {
                DatabaseState::CONNECTED_AWAIT_INIT
            }
            _ => DatabaseState::FAILED,
        }
    }

    pub fn store(&self, state: DatabaseState) {
        self.inner.store(state as u8, Ordering::Relaxed);
    }
}

/* ============================
 * Query State
 * ============================ */

#[derive(Debug, Clone, Copy, PartialEq)]
#[repr(u8)]
pub enum QueryState {
    Processing,
    Done,
    InvalidArgument,
    TransientFailure,
}

impl TryFrom<u8> for QueryState {
    type Error = std::io::Error;

    fn try_from(value: u8) -> Result<Self, Self::Error> {
        match value {
            0 => Ok(QueryState::Processing),
            1 => Ok(QueryState::Done),
            2 => Ok(QueryState::InvalidArgument),
            3 => Ok(QueryState::TransientFailure),
            _ => Err(std::io::Error::new(
                std::io::ErrorKind::InvalidInput,
                "Unknown enum value",
            )),
        }
    }
}

#[derive(Debug, IntoArma)]
pub struct QueryError {
    #[arma(to_string)]
    pub code: &'static str,
    #[arma(to_string)]
    pub message: String,
    #[arma(to_string)]
    pub location: String,
}

pub struct QueryResult {
    pub state: QueryState,
    pub error: Option<QueryError>,
}

impl IntoArma for QueryResult {
    fn to_arma(&self) -> arma_rs::Value {
        let mut vec = vec![self.state.to_arma()];
        if let Some(e) = &self.error {
            vec.push(e.to_arma());
        }
        arma_rs::Value::Array(vec)
    }
}

/* ============================
 * Arma Integration
 * ============================ */

impl IntoArma for DatabaseState {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::Number((*self as u8).into())
    }
}

impl IntoArma for QueryState {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::Number((*self as u8).into())
    }
}

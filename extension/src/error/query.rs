// src/extension_new/error/query.rs
//
// Query state and result types for Arma interop.
// These types represent the outcome of async operations.

use arma_rs::{FromArma, IntoArma};

/// State of an async query/operation.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum QueryState {
    /// Operation is in progress (async)
    Processing = 0,
    /// Operation completed successfully
    Done = 1,
    /// Invalid argument provided
    InvalidArgument = 2,
    /// Transient failure (may be retried)
    TransientFailure = 3,
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
                "Unknown QueryState value",
            )),
        }
    }
}

impl IntoArma for QueryState {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::Number((*self as u8).into())
    }
}

impl FromArma for QueryState {
    fn from_arma(s: String) -> Result<Self, arma_rs::FromArmaError> {
        let v: u8 = s
            .parse()
            .map_err(|_| arma_rs::FromArmaError::Custom("Invalid number".into()))?;
        QueryState::try_from(v)
            .map_err(|_| arma_rs::FromArmaError::Custom("Invalid enum value".into()))
    }
}

/// Error details for failed queries.
#[derive(Debug, IntoArma, FromArma)]
pub struct QueryError {
    #[arma(to_string)]
    pub code: String,
    #[arma(to_string)]
    pub message: String,
    #[arma(to_string)]
    pub location: String,
}

/// Result of an async query/operation.
#[derive(Debug)]
pub struct QueryResult {
    pub state: QueryState,
    pub error: Option<QueryError>,
}

impl QueryResult {
    /// Create a simple result with no error.
    pub fn new(state: QueryState) -> Self {
        Self { state, error: None }
    }

    /// Create a successful "done" result.
    pub fn done() -> Self {
        Self::new(QueryState::Done)
    }

    /// Create a "processing" result for async operations.
    pub fn processing() -> Self {
        Self::new(QueryState::Processing)
    }
}

impl PartialEq<QueryState> for QueryResult {
    fn eq(&self, other: &QueryState) -> bool {
        &self.state == other
    }
}

impl IntoArma for QueryResult {
    fn to_arma(&self) -> arma_rs::Value {
        if let Some(error) = &self.error {
            arma_rs::Value::Array(vec![self.state.to_arma(), error.to_arma()])
        } else {
            arma_rs::Value::Array(vec![self.state.to_arma()])
        }
    }
}

impl FromArma for QueryResult {
    fn from_arma(s: String) -> Result<Self, arma_rs::FromArmaError> {
        let value = arma_rs::Value::from_arma(s)?;

        if let arma_rs::Value::Array(arr) = value {
            if arr.is_empty() {
                return Err(arma_rs::FromArmaError::InvalidLength {
                    expected: 1,
                    actual: 0,
                });
            }

            let state = QueryState::from_arma(arr[0].to_string())?;
            let error = if arr.len() > 1 {
                Some(QueryError::from_arma(arr[1].to_string())?)
            } else {
                None
            };

            Ok(QueryResult { state, error })
        } else {
            Err(arma_rs::FromArmaError::InvalidPrimitive(
                "Expected array".into(),
            ))
        }
    }
}

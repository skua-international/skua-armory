// src/extension_new/core/context.rs
//
// Abstraction of arma_rs::Context to allow for easier testing and extension.

use arma_rs::Context as ArmaContext;
use std::error::Error;

#[derive(Debug)]
pub enum CallbackError {
    SerializationError(serde_json::Error),
    CallbackNotFound,
    CallbackDataMismatch,
    ArmaError(arma_rs::CallbackError),
}

impl std::fmt::Display for CallbackError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::SerializationError(e) => write!(f, "Serialization error: {}", e),
            Self::CallbackNotFound => write!(f, "Callback not found"),
            Self::CallbackDataMismatch => write!(f, "Callback data mismatch"),
            Self::ArmaError(e) => write!(f, "Arma callback error: {}", e),
        }
    }
}

impl Error for CallbackError {}

pub trait ContextProvider {
    fn callback_data<V>(&self, name: &str, func: &str, data: V) -> Result<(), CallbackError>
    where
        V: serde::Serialize + arma_rs::IntoArma;
}

// Send + Sync are required for using ContextProvider in async contexts
impl<T: ContextProvider + Send + Sync + 'static> ContextProvider for &T {
    fn callback_data<V>(&self, name: &str, func: &str, data: V) -> Result<(), CallbackError>
    where
        V: serde::Serialize + arma_rs::IntoArma,
    {
        (*self).callback_data(name, func, data)
    }
}

impl ContextProvider for ArmaContext {
    fn callback_data<V>(&self, name: &str, func: &str, data: V) -> Result<(), CallbackError>
    where
        V: serde::Serialize + arma_rs::IntoArma,
    {
        ArmaContext::callback_data(self, name, func, data).map_err(CallbackError::ArmaError)
    }
}

// In tests only
#[cfg(test)]
pub struct MockContext {
    pub calls: std::cell::RefCell<Vec<(String, String, String)>>,
}

#[cfg(test)]
impl MockContext {
    pub fn new() -> Self {
        Self {
            calls: std::cell::RefCell::new(Vec::new()),
        }
    }
}

#[cfg(test)]
impl ContextProvider for MockContext {
    fn callback_data<V>(&self, name: &str, func: &str, data: V) -> Result<(), CallbackError>
    where
        V: serde::Serialize + arma_rs::IntoArma,
    {
        let serialized = serde_json::to_string(&data).map_err(CallbackError::SerializationError)?;
        self.calls
            .borrow_mut()
            .push((name.to_string(), func.to_string(), serialized));
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use arma_rs::IntoArma;
    use serde::Serialize;

    #[derive(Serialize, IntoArma)]
    struct TestData {
        value: u32,
    }

    #[test]
    fn test_mock_context_callback() {
        let ctx = MockContext::new();
        let data = TestData { value: 42 };

        ctx.callback_data("test_module", "test_function", data)
            .unwrap();

        let calls = ctx.calls.borrow();
        assert_eq!(calls.len(), 1);
        assert_eq!(calls[0].0, "test_module");
        assert_eq!(calls[0].1, "test_function");
        assert_eq!(calls[0].2, r#"{"value":42}"#);
    }
}

// src/database/test_support.rs
#[cfg(test)]
use std::sync::{Once, OnceLock};
#[cfg(test)]
use tokio::runtime::{Builder, Runtime};

#[cfg(test)]
static INIT: Once = Once::new();

#[cfg(test)]
pub fn init_logging() {
    INIT.call_once(|| {
        let _ = tracing_subscriber::fmt()
            .with_test_writer() // <-- important for tests
            .with_target(true)
            .try_init();
    });
}

#[cfg(test)]
pub fn enter_test_runtime() -> tokio::runtime::EnterGuard<'static> {
    static RT: OnceLock<Runtime> = OnceLock::new();

    RT.get_or_init(|| {
        Builder::new_multi_thread()
            .enable_all()
            .build()
            .expect("failed to build Tokio runtime")
    })
    .enter()
}

#[cfg(test)]
use crate::database::types::QueryState;
#[cfg(test)]
use arma_rs::{Extension, testing};

#[cfg(test)]
pub fn call_bootstrap(extension: &testing::Extension, key: &str) {
    let (state, code) = extension.call("database:bootstrap", Some(vec![key.to_string()]));

    assert_eq!(code, 0, "bootstrap returned error code");

    let state: u8 = state.parse().expect("bootstrap returned non-number");
    let state = QueryState::try_from(state).expect("invalid QueryState");

    assert_eq!(state, QueryState::Processing);
}

#[cfg(test)]
use arma_rs::{Result, Value};

#[cfg(test)]
pub fn wait_for_query_state(
    extension: &testing::Extension,
    ext_name: &str,
    func_name: &str,
    timeout: std::time::Duration,
) -> QueryState {
    let result = extension.callback_handler(
        move |name, func, data| {
            if name == ext_name && func == func_name {
                match data {
                    Some(Value::Number(v)) => Result::Ok(QueryState::try_from(v as u8).unwrap()),
                    Some(Value::Array(v)) => {
                        let v = v.get(0).unwrap();
                        let state = QueryState::try_from(v as u8).unwrap();

                        Result::Ok(state)
                    }
                    _ => Result::Err("invalid callback payload"),
                }
            } else {
                Result::Err("not our callback")
            }
        },
        timeout,
    );

    match result {
        Result::Ok(r) => r,
        Result::Err(e) => panic!("error:{}", e),
        Result::Timeout => panic!("timed out"),
        Result::Continue => panic!("not handled"),
    }
}

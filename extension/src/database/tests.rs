// src/database/tests.rs

#[cfg(test)]
mod tests {
    use crate::database::test_support::*;
    use crate::database::types::QueryState;
    use arma_rs::Extension;
    use std::time::Duration;
    use tracing::info;
    use uuid::Uuid;

    #[test]
    fn bootstrap_is_idempotent() {
        let _rt = enter_test_runtime();
        init_logging();
        info!("test started");

        let key = Uuid::now_v7().to_string();

        let extension = Extension::build()
            .group("database", crate::database::group())
            .finish()
            .testing();

        call_bootstrap(&extension, &key);
        assert_eq!(
            wait_for_query_state(
                &extension,
                "skua:database",
                "bootstrap",
                Duration::from_secs(2)
            ),
            QueryState::Done
        );

        // Second call must also succeed
        call_bootstrap(&extension, &key);
        assert_eq!(
            wait_for_query_state(
                &extension,
                "skua:database",
                "bootstrap",
                Duration::from_secs(2)
            ),
            QueryState::Done
        );
    }
}

// src/extension/database/tests.rs
//
// Database integration tests using testcontainers.

#[cfg(test)]
mod integration_tests {
    use std::time::Duration;

    use anyhow::anyhow;
    use deadpool_postgres::{Manager, Pool};
    use testcontainers_modules::postgres::Postgres;
    use testcontainers_modules::testcontainers::ImageExt;
    use testcontainers_modules::testcontainers::runners::AsyncRunner;
    use tokio_postgres::{Config, NoTls};
    use uuid::Uuid;

    use crate::{
        QueryState,
        database::schema::{bootstrap, sanitize_key},
    };
    use arma_rs::FromArma;

    /// Helper to create a connection pool for a testcontainer postgres instance.
    async fn create_test_pool(host: &str, port: u16) -> Pool {
        let mut cfg = Config::new();
        cfg.host(host);
        cfg.port(port);
        cfg.user("postgres");
        cfg.password("postgres");
        cfg.dbname("postgres");

        let manager = Manager::new(cfg, NoTls);
        Pool::builder(manager)
            .max_size(4)
            .build()
            .expect("Failed to build test pool")
    }

    /// Query to check if a schema exists.
    const SCHEMA_EXISTS_QUERY: &str = r#"
        SELECT EXISTS (
            SELECT 1 FROM information_schema.schemata
            WHERE schema_name = $1
        )
    "#;

    /// Query to check if a table exists in a schema.
    const TABLE_EXISTS_QUERY: &str = r#"
        SELECT EXISTS (
            SELECT 1 FROM information_schema.tables
            WHERE table_schema = $1 AND table_name = $2
        )
    "#;

    /// Query to check if an index exists.
    const INDEX_EXISTS_QUERY: &str = r#"
        SELECT EXISTS (
            SELECT 1 FROM pg_indexes
            WHERE schemaname = $1 AND indexname = $2
        )
    "#;

    /// Query to check if a function exists.
    const FUNCTION_EXISTS_QUERY: &str = r#"
        SELECT EXISTS (
            SELECT 1 FROM information_schema.routines
            WHERE routine_schema = $1 AND routine_name = $2
        )
    "#;

    /// Query to check if a trigger exists.
    const TRIGGER_EXISTS_QUERY: &str = r#"
        SELECT EXISTS (
            SELECT 1 FROM information_schema.triggers
            WHERE trigger_schema = $1 AND trigger_name = $2
        )
    "#;

    // =========================================================================
    // Test: Master schema bootstrap creates all schemas and tables
    // =========================================================================

    #[tokio::test]
    async fn test_bootstrap_master_creates_all_schemas_and_tables() {
        // Start postgres container
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        let extension = arma_rs::Extension::build().finish().testing();
        let ctx = extension.context();

        let no_campaign_id: String = "".to_string();

        let state = bootstrap(ctx, no_campaign_id);
        assert_eq!(
            state,
            QueryState::Processing,
            "Bootstrap should be processing"
        );

        let result: arma_rs::Result<_, _> = extension.callback_handler(
            |ext, func, data| {
                // Check if this is our bootstrap callback
                if ext != "skua:database" && func != "bootstrap_complete" {
                    return arma_rs::Result::Err(anyhow!("not our callback"));
                }

                if data.is_none() {
                    return arma_rs::Result::Err(anyhow!("no data in callback"));
                }

                // Deserialize result
                if let Ok(data) = arma_rs::Value::from_arma(data.unwrap().to_string()) {
                    return arma_rs::Result::Ok(data);
                } else {
                    return arma_rs::Result::Err(anyhow!("failed to deserialize"));
                }
            },
            Duration::from_secs(20),
        );
        assert!(
            result.is_ok(),
            "Bootstrap callback should return successfully"
        );

        // Verify master schema exists
        let schema_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&"skua_master"])
            .await
            .expect("Schema query failed")
            .get(0);
        assert!(schema_exists, "skua_master schema should exist");

        // Verify all master tables exist
        let expected_tables = [
            "ranks",
            "certifications",
            "campaigns",
            "player_info",
            "player_certs",
            "sessions",
        ];

        for table in expected_tables {
            let table_exists: bool = client
                .query_one(TABLE_EXISTS_QUERY, &[&"skua_master", &table])
                .await
                .expect(&format!("Table query failed for {}", table))
                .get(0);
            assert!(table_exists, "Table {} should exist in skua_master", table);
        }

        // Verify indexes exist
        let expected_indexes = [
            ("skua_master", "idx_player_info_is_admin"),
            ("skua_master", "idx_player_info_is_banned"),
            ("skua_master", "idx_player_certs_steam_id"),
            ("skua_master", "idx_player_certs_cert_uuid"),
            ("skua_master", "idx_sessions_is_active"),
            ("skua_master", "idx_sessions_campaign_id"),
        ];

        for (schema, index) in expected_indexes {
            let index_exists: bool = client
                .query_one(INDEX_EXISTS_QUERY, &[&schema, &index])
                .await
                .expect(&format!("Index query failed for {}", index))
                .get(0);
            assert!(index_exists, "Index {} should exist in {}", index, schema);
        }

        // Verify functions exist
        let expected_functions = [
            "update_heartbeat",
            "promote_ephemeral_player_data",
            "cleanup_expired_sessions",
            "expire_stale_sessions",
        ];

        for func in expected_functions {
            let func_exists: bool = client
                .query_one(FUNCTION_EXISTS_QUERY, &[&"skua_master", &func])
                .await
                .expect(&format!("Function query failed for {}", func))
                .get(0);
            assert!(func_exists, "Function {} should exist in skua_master", func);
        }

        // Verify trigger exists
        let trigger_exists: bool = client
            .query_one(
                TRIGGER_EXISTS_QUERY,
                &[&"skua_master", &"trg_update_session_heartbeat"],
            )
            .await
            .expect("Trigger query failed")
            .get(0);
        assert!(trigger_exists, "trg_update_session_heartbeat should exist");
    }

    // =========================================================================
    // Test: Campaign schema bootstrap creates all tables
    // =========================================================================

    /* #[tokio::test]
    async fn test_bootstrap_campaign_creates_all_tables() {
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        // First bootstrap master (campaign depends on master)
        bootstrap_master(&client)
            .await
            .expect("bootstrap_master should succeed");

        // Bootstrap campaign
        let campaign_id = "test_campaign";
        let result = bootstrap_campaign(&client, campaign_id).await;
        assert!(
            result.is_ok(),
            "bootstrap_campaign should succeed: {:?}",
            result.err()
        );

        // Verify campaign schema exists
        let schema_name = format!("skua_campaign_{}", campaign_id);
        let schema_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&schema_name])
            .await
            .expect("Schema query failed")
            .get(0);
        assert!(
            schema_exists,
            "Campaign schema {} should exist",
            schema_name
        );

        // Verify campaign tables exist
        let expected_tables = ["player_data", "player_world_data", "world_data"];

        for table in expected_tables {
            let table_exists: bool = client
                .query_one(TABLE_EXISTS_QUERY, &[&schema_name.as_str(), &table])
                .await
                .expect(&format!("Table query failed for {}", table))
                .get(0);
            assert!(
                table_exists,
                "Table {} should exist in {}",
                table, schema_name
            );
        }

        // Verify campaign indexes exist
        let expected_indexes = ["idx_player_world_data_world", "idx_world_data_world"];

        for index in expected_indexes {
            let index_exists: bool = client
                .query_one(INDEX_EXISTS_QUERY, &[&schema_name.as_str(), &index])
                .await
                .expect(&format!("Index query failed for {}", index))
                .get(0);
            assert!(
                index_exists,
                "Index {} should exist in {}",
                index, schema_name
            );
        }

        // Verify campaign was registered in master.campaigns
        let campaign_registered: bool = client
            .query_one(
                "SELECT EXISTS (SELECT 1 FROM skua_master.campaigns WHERE campaign_id = $1)",
                &[&schema_name],
            )
            .await
            .expect("Campaign registration query failed")
            .get(0);
        assert!(
            campaign_registered,
            "Campaign should be registered in skua_master.campaigns"
        );
    }

    // =========================================================================
    // Test: Session schema bootstrap creates all tables
    // =========================================================================

    #[tokio::test]
    async fn test_bootstrap_session_creates_all_tables() {
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        // First bootstrap master (session depends on master)
        bootstrap_master(&client)
            .await
            .expect("bootstrap_master should succeed");

        // Bootstrap session
        let session_id = Uuid::now_v7();
        let result = bootstrap_session(&client, &session_id).await;
        assert!(
            result.is_ok(),
            "bootstrap_session should succeed: {:?}",
            result.err()
        );

        // Verify session schema exists
        let schema_key = session_id.to_string().replace('-', "_");
        let schema_name = format!("skua_session_{}", schema_key);
        let schema_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&schema_name])
            .await
            .expect("Schema query failed")
            .get(0);
        assert!(schema_exists, "Session schema {} should exist", schema_name);

        // Verify session tables exist
        let table_exists: bool = client
            .query_one(TABLE_EXISTS_QUERY, &[&schema_name.as_str(), &"player_data"])
            .await
            .expect("Table query failed for player_data")
            .get(0);
        assert!(
            table_exists,
            "Table player_data should exist in {}",
            schema_name
        );

        // Verify session index exists
        let index_exists: bool = client
            .query_one(
                INDEX_EXISTS_QUERY,
                &[&schema_name.as_str(), &"idx_player_data_deadline"],
            )
            .await
            .expect("Index query failed")
            .get(0);
        assert!(index_exists, "Index idx_player_data_deadline should exist");

        // Verify function exists
        let func_exists: bool = client
            .query_one(
                FUNCTION_EXISTS_QUERY,
                &[&schema_name.as_str(), &"promote_on_save"],
            )
            .await
            .expect("Function query failed")
            .get(0);
        assert!(func_exists, "Function promote_on_save should exist");

        // Verify trigger exists
        let trigger_exists: bool = client
            .query_one(
                TRIGGER_EXISTS_QUERY,
                &[&schema_name.as_str(), &"trg_ephemeral_player_data_promote"],
            )
            .await
            .expect("Trigger query failed")
            .get(0);
        assert!(
            trigger_exists,
            "trg_ephemeral_player_data_promote should exist"
        );
    }

    // =========================================================================
    // Test: Bootstrap is idempotent (running twice should not fail)
    // =========================================================================

    #[tokio::test]
    async fn test_bootstrap_master_is_idempotent() {
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        // First bootstrap
        let result1 = bootstrap_master(&client).await;
        assert!(
            result1.is_ok(),
            "First bootstrap_master should succeed: {:?}",
            result1.err()
        );

        // Second bootstrap (should also succeed - idempotent)
        let result2 = bootstrap_master(&client).await;
        assert!(
            result2.is_ok(),
            "Second bootstrap_master should succeed (idempotent): {:?}",
            result2.err()
        );

        // Verify schema still exists and is intact
        let schema_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&"skua_master"])
            .await
            .expect("Schema query failed")
            .get(0);
        assert!(
            schema_exists,
            "skua_master schema should still exist after double bootstrap"
        );
    }

    #[tokio::test]
    async fn test_bootstrap_campaign_is_idempotent() {
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        // Bootstrap master first
        bootstrap_master(&client)
            .await
            .expect("bootstrap_master should succeed");

        let campaign_id = "idempotent_test";

        // First campaign bootstrap
        let result1 = bootstrap_campaign(&client, campaign_id).await;
        assert!(
            result1.is_ok(),
            "First bootstrap_campaign should succeed: {:?}",
            result1.err()
        );

        // Second campaign bootstrap (should also succeed - idempotent)
        let result2 = bootstrap_campaign(&client, campaign_id).await;
        assert!(
            result2.is_ok(),
            "Second bootstrap_campaign should succeed (idempotent): {:?}",
            result2.err()
        );

        // Verify schema still exists
        let schema_name = format!("skua_campaign_{}", campaign_id);
        let schema_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&schema_name])
            .await
            .expect("Schema query failed")
            .get(0);
        assert!(
            schema_exists,
            "Campaign schema should still exist after double bootstrap"
        );
    }

    #[tokio::test]
    async fn test_bootstrap_session_is_idempotent() {
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        // Bootstrap master first
        bootstrap_master(&client)
            .await
            .expect("bootstrap_master should succeed");

        let session_id = Uuid::now_v7();

        // First session bootstrap
        let result1 = bootstrap_session(&client, &session_id).await;
        assert!(
            result1.is_ok(),
            "First bootstrap_session should succeed: {:?}",
            result1.err()
        );

        // Second session bootstrap (should also succeed - idempotent)
        let result2 = bootstrap_session(&client, &session_id).await;
        assert!(
            result2.is_ok(),
            "Second bootstrap_session should succeed (idempotent): {:?}",
            result2.err()
        );

        // Verify schema still exists
        let schema_key = session_id.to_string().replace('-', "_");
        let schema_name = format!("skua_session_{}", schema_key);
        let schema_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&schema_name])
            .await
            .expect("Schema query failed")
            .get(0);
        assert!(
            schema_exists,
            "Session schema should still exist after double bootstrap"
        );
    }

    // =========================================================================
    // Test: Bootstrap fails gracefully when database is unavailable
    // =========================================================================

    #[tokio::test]
    async fn test_bootstrap_master_fails_when_database_unavailable() {
        // Create pool pointing to non-existent database
        let mut cfg = Config::new();
        cfg.host("127.0.0.1");
        cfg.port(59999); // Port that's almost certainly not running postgres
        cfg.user("postgres");
        cfg.password("postgres");
        cfg.dbname("postgres");
        cfg.connect_timeout(std::time::Duration::from_secs(1));

        let manager = Manager::new(cfg, NoTls);
        let pool = Pool::builder(manager)
            .max_size(1)
            .build()
            .expect("Failed to build test pool");

        // Attempting to get a client should fail
        let client_result = pool.get().await;
        assert!(
            client_result.is_err(),
            "Getting client should fail when database is unavailable"
        );
    }

    #[tokio::test]
    async fn test_bootstrap_fails_with_invalid_connection() {
        // Use a deliberately wrong configuration
        let mut cfg = Config::new();
        cfg.host("invalid-host-that-does-not-exist.local");
        cfg.port(5432);
        cfg.user("postgres");
        cfg.password("postgres");
        cfg.dbname("postgres");
        cfg.connect_timeout(std::time::Duration::from_secs(1));

        let manager = Manager::new(cfg, NoTls);
        let pool = Pool::builder(manager)
            .max_size(1)
            .build()
            .expect("Failed to build test pool");

        // Attempting to get a client should fail due to DNS resolution
        let client_result = pool.get().await;
        assert!(
            client_result.is_err(),
            "Getting client should fail with invalid host"
        );
    }

    // =========================================================================
    // Test: Full bootstrap flow (master + campaign + session)
    // =========================================================================

    #[tokio::test]
    async fn test_full_bootstrap_flow() {
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        // Bootstrap in order: master -> campaign -> session
        let campaign_id = "full_test_campaign";
        let session_id = Uuid::now_v7();

        // Master
        bootstrap_master(&client)
            .await
            .expect("bootstrap_master should succeed");

        // Campaign
        bootstrap_campaign(&client, campaign_id)
            .await
            .expect("bootstrap_campaign should succeed");

        // Session
        bootstrap_session(&client, &session_id)
            .await
            .expect("bootstrap_session should succeed");

        // Verify all three schemas exist
        let master_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&"skua_master"])
            .await
            .expect("Query failed")
            .get(0);
        assert!(master_exists, "Master schema should exist");

        let campaign_schema = format!("skua_campaign_{}", campaign_id);
        let campaign_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&campaign_schema])
            .await
            .expect("Query failed")
            .get(0);
        assert!(campaign_exists, "Campaign schema should exist");

        let session_schema = format!("skua_session_{}", session_id.to_string().replace('-', "_"));
        let session_exists: bool = client
            .query_one(SCHEMA_EXISTS_QUERY, &[&session_schema])
            .await
            .expect("Query failed")
            .get(0);
        assert!(session_exists, "Session schema should exist");
    }

    // =========================================================================
    // Test: Multiple campaigns and sessions can coexist
    // =========================================================================

    #[tokio::test]
    async fn test_multiple_campaigns_and_sessions() {
        let container = Postgres::default()
            .with_tag("18-alpine")
            .start()
            .await
            .expect("Failed to start postgres container");

        let host = container.get_host().await.expect("Failed to get host");
        let port = container
            .get_host_port_ipv4(5432)
            .await
            .expect("Failed to get port");

        let pool = create_test_pool(&host.to_string(), port).await;
        let client = pool.get().await.expect("Failed to get client");

        // Bootstrap master
        bootstrap_master(&client)
            .await
            .expect("bootstrap_master should succeed");

        // Create multiple campaigns
        let campaigns = ["campaign_alpha", "campaign_beta", "campaign_gamma"];
        for campaign in campaigns {
            bootstrap_campaign(&client, campaign).await.expect(&format!(
                "bootstrap_campaign for {} should succeed",
                campaign
            ));
        }

        // Create multiple sessions
        let sessions: Vec<Uuid> = (0..3).map(|_| Uuid::now_v7()).collect();
        for session_id in &sessions {
            bootstrap_session(&client, session_id)
                .await
                .expect("bootstrap_session should succeed");
        }

        // Verify all campaigns exist
        for campaign in campaigns {
            let schema_name = format!("skua_campaign_{}", campaign);
            let exists: bool = client
                .query_one(SCHEMA_EXISTS_QUERY, &[&schema_name])
                .await
                .expect("Query failed")
                .get(0);
            assert!(exists, "Campaign schema {} should exist", schema_name);
        }

        // Verify all sessions exist
        for session_id in &sessions {
            let schema_name = format!("skua_session_{}", session_id.to_string().replace('-', "_"));
            let exists: bool = client
                .query_one(SCHEMA_EXISTS_QUERY, &[&schema_name])
                .await
                .expect("Query failed")
                .get(0);
            assert!(exists, "Session schema {} should exist", schema_name);
        }
    } */
}

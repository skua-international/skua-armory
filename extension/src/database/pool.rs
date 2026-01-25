// src/extension/database/pool.rs
//
// Database connection pool management.
// Uses deadpool-postgres for async connection pooling.

use deadpool_postgres::{Manager, Pool};
use std::env;
use tokio::sync::OnceCell;
use tokio_postgres::{Config, NoTls};
use tracing::info;

use super::state::{AtomicDatabaseState, DatabaseState};
use crate::error::DbError;

/// Global database instance (lazy initialized).
static DATABASE: OnceCell<Database> = OnceCell::const_new();

/// Database wrapper containing the connection pool and state.
pub struct Database {
    pool: Pool,
    state: AtomicDatabaseState,
}

impl Database {
    /// Initialize from environment variables.
    async fn init_from_env() -> Result<Self, tokio_postgres::Error> {
        let mut cfg = Config::new();

        // Use 127.0.0.1 - may run inside Proton without localhost resolution
        cfg.host(&env::var("DATABASE_HOST").unwrap_or_else(|_| "127.0.0.1".into()));
        cfg.port(
            env::var("DATABASE_PORT")
                .ok()
                .and_then(|v| v.parse().ok())
                .unwrap_or(55432),
        );
        cfg.user(&env::var("DATABASE_USER").unwrap_or_else(|_| "postgres".into()));
        cfg.password(&env::var("DATABASE_PASSWORD").unwrap_or_else(|_| "changeit".into()));
        cfg.dbname(&env::var("DATABASE_NAME").unwrap_or_else(|_| "postgres".into()));

        let pool_size = env::var("DATABASE_POOL_SIZE")
            .ok()
            .and_then(|v| v.parse().ok())
            .unwrap_or(16);

        let manager = Manager::new(cfg, NoTls);
        let pool = Pool::builder(manager)
            .max_size(pool_size)
            .build()
            .expect("Failed to build postgres pool");

        Ok(Self {
            pool,
            state: AtomicDatabaseState::new(DatabaseState::ConnectedAwaitInit),
        })
    }

    /// Get a connection from the pool.
    pub async fn get_conn(
        &self,
    ) -> Result<deadpool_postgres::Client, deadpool_postgres::PoolError> {
        self.pool.get().await
    }

    /// Get the current database state.
    pub fn state(&self) -> DatabaseState {
        if self.pool.is_closed() {
            return DatabaseState::AwaitConnect;
        }

        let status = self.pool.status();
        if status.available == 0 && status.size == 0 {
            return DatabaseState::AwaitConnect;
        }

        self.state.load()
    }

    /// Set the database state.
    pub fn set_state(&self, state: DatabaseState) {
        self.state.store(state);
    }
}

/// Get the global database instance, initializing if necessary.
pub async fn get_db() -> Result<&'static Database, tokio_postgres::Error> {
    DATABASE.get_or_try_init(Database::init_from_env).await
}

/// Get a database client directly from the connection pool.
///
/// This is the preferred way to get a database connection for most operations.
pub async fn get_client() -> Result<deadpool_postgres::Client, DbError> {
    let db = get_db().await.map_err(DbError::Init)?;
    db.get_conn().await.map_err(DbError::Pool)
}

/// Get the current database state without initializing.
pub fn get_state() -> DatabaseState {
    DATABASE
        .get()
        .map(|db| db.state())
        .unwrap_or(DatabaseState::AwaitConnect)
}

/// Get the current database state (Arma command).
pub fn get_database_state() -> DatabaseState {
    info!("Database state requested");
    let state = get_state();
    info!(?state, "Database state returned");
    state
}

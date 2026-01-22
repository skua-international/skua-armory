use deadpool_postgres::{Manager, Pool};
use std::env;
use std::sync::OnceLock;
use tokio_postgres::{Config, NoTls};

use crate::database::types::{AtomicDatabaseState, DatabaseState};

/* ============================
 * Database Struct
 * ============================ */

pub struct DB {
    pool: Pool,
    state: AtomicDatabaseState,
}

/* ============================
 * Global Database (lazy)
 * ============================ */

static DATABASE: OnceLock<DB> = OnceLock::new();

/* ============================
 * DB Implementation
 * ============================ */

impl DB {
    async fn init_from_env() -> Result<Self, tokio_postgres::Error> {
        let mut cfg = Config::new();

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
            state: AtomicDatabaseState::new(DatabaseState::CONNECTED_AWAIT_INIT),
        })
    }

    pub async fn get_conn(
        &self,
    ) -> Result<deadpool_postgres::Client, deadpool_postgres::PoolError> {
        self.pool.get().await
    }

    pub fn state(&self) -> DatabaseState {
        self.state.load()
    }

    pub fn set_state(&self, state: DatabaseState) {
        self.state.store(state);
    }
}

/* ============================
 * Global Accessor (lazy init)
 * ============================ */

pub async fn get_db() -> Result<&'static DB, tokio_postgres::Error> {
    if let Some(db) = DATABASE.get() {
        return Ok(db);
    }

    let db = DB::init_from_env().await?;

    // Ignore error if another task raced us
    let _ = DATABASE.set(db);

    Ok(DATABASE.get().unwrap())
}

fn get_db_state() -> Option<DatabaseState> {
    DATABASE.get().map(|db| db.state())
}

pub fn get_database_state() -> DatabaseState {
    get_db_state().unwrap_or_else(|| DatabaseState::AWAIT_CONNECT)
}

/* ============================
 * Graceful Shutdown
 * ============================ */

pub async fn shutdown_db() {
    if let Some(db) = DATABASE.get() {
        db.pool.close();
    }
}

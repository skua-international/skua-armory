use std::error::Error;

use arma_rs::Context;
use regex::Regex;

use tracing::{error, info};

use crate::database::db::{DB, get_db};
use crate::database::types::{DatabaseState, QueryError, QueryResult, QueryState};

const SQL_MASTER_SCHEMA: &str = include_str!("sql/create_master_schema.sql");
const SQL_MASTER_PLAYER_INFO: &str = include_str!("sql/create_master_player_info.sql");
const SQL_MASTER_RANKS: &str = include_str!("sql/create_master_ranks.sql");
const SQL_MASTER_CERTS: &str = include_str!("sql/create_master_certifications.sql");
const SQL_MASTER_P_CERTS: &str = include_str!("sql/create_master_player_certs.sql");
const SQL_CAMPAIGN_SCHEMA: &str = include_str!("sql/create_campaign_schema.sql");
const SQL_CAMPAIGN_PLAYER_DATA: &str = include_str!("sql/create_campaign_player_data.sql");
//const SQL_CAMPAIGN_WORLD_DATA: &str = include_str!("sql/create_campaign_world_data.sql");

/// transient error logs an error and creates an error structure that can be read in Arma
#[track_caller]
fn transient_error<E>(message: &'static str, error: E) -> QueryResult
where
    E: Error,
{
    let loc = std::panic::Location::caller();

    error!(
        error = %error,
        file = loc.file(),
        line = loc.line(),
        column = loc.column(),
        "{}",
        message
    );

    QueryResult {
        state: QueryState::TransientFailure,
        error: Some(QueryError {
            code: "UNAVAILABLE",
            message: format!("{}: {}", message, error),
            location: format!("{}:{}", loc.file(), loc.line()),
        }),
    }
}

/// do_bootstrap performs various database calls to ensure the necessary schemas and tables
/// for operation exist
async fn do_bootstrap<'a>(key: String) -> QueryResult {
    let db: &DB = match get_db().await {
        Ok(db) => db,
        Err(e) => {
            return transient_error("Failed to acquire database handle", e);
        }
    };

    let client = match db.get_conn().await {
        Ok(c) => c,
        Err(e) => {
            return transient_error("Failed to acquire database connection from pool", e);
        }
    };

    // Master Schema, campaign-agnostic player info
    if let Err(e) = client.execute(SQL_MASTER_SCHEMA, &[]).await {
        return transient_error("Failed to create master schema", e);
    }

    if let Err(e) = client.execute(SQL_MASTER_PLAYER_INFO, &[]).await {
        return transient_error("Failed to create master player info table", e);
    }

    if let Err(e) = client.execute(SQL_MASTER_RANKS, &[]).await {
        return transient_error("Failed to create master ranks table", e);
    }

    if let Err(e) = client.execute(SQL_MASTER_CERTS, &[]).await {
        return transient_error("Failed to create master certifications table", e);
    }

    if let Err(e) = client.execute(SQL_MASTER_P_CERTS, &[]).await {
        return transient_error("Failed to create master certification assignment table", e);
    }

    // Campaign schema, campaign-specific player data
    // Location, medical status, loadout
    let sql = SQL_CAMPAIGN_SCHEMA.replace("${schema}", &key);
    if let Err(e) = client.execute(&sql, &[]).await {
        if let Some(e) = e.as_db_error() {
            error!("DB Error: code: {:?}, message: {}", e.code(), e.message())
        }
        return transient_error("Failed to create campaign schema", e);
    }

    let sql = SQL_CAMPAIGN_SCHEMA.replace("${schema}", &key);
    if let Err(e) = client.execute(&sql, &[]).await {
        return transient_error("Failed to create campaign player data table", e);
    }

    info!(schema = %key, "bootstrap finished");
    db.set_state(DatabaseState::CONNECTED_INIT);

    QueryResult {
        state: QueryState::Done,
        error: None,
    }
}

fn sanitize_key(key: String) -> Result<String, &'static str> {
    let key = key.replace('-', "_").replace(' ', "_").to_lowercase();

    let re = Regex::new(r"^[a-z0-9_]{3,49}$").unwrap();

    if !re.is_match(&key) {
        return Err("invalid key pattern");
    }

    Ok(format!("skua_campaign_{}", key))
}

pub fn bootstrap(ctx: Context, key: String) -> QueryState {
    let key = match sanitize_key(key) {
        Ok(k) => k,
        Err(_) => return QueryState::InvalidArgument,
    };

    tokio::spawn(async move {
        info!(schema = %key, "starting database bootstrap");

        let state: QueryResult = do_bootstrap(key).await;

        if let Err(e) = ctx.callback_data("skua:database", "bootstrap", state) {
            error!(error = %e, "failed to send bootstrap callback to Arma");
        }
    });

    QueryState::Processing
}

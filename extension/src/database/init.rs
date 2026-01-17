use arma_rs::{Context, ContextState};

use crate::database::{DB, DatabaseState};

/// init initializes the connection pool and runs a test query to confirm everything is working
/// if the target database does not exist, the client will attempt to connect to the "postgres" database with the same user
/// and create the specified database
/// 
pub fn init(
    ctx: Context,
    host: &String,
    port: &u16,
    database: &String,
    user: &String,
    password: &String
) -> DatabaseState {
    

    DatabaseState::CONNECTING
}
use arma_rs::{Context};
use crate::database::DatabaseState;

pub fn connect(
    ctx: Context,
    _host: String,
    _port: u16,
    _user: String,
    _password: String,
    _database: String
) -> DatabaseState {
    std::thread::spawn(move || {
        ctx.callback_data("skua:database", "connect", DatabaseState::FAILED)
    });

    DatabaseState::CONNECTING
}
use arma_rs::{Group, IntoArma};

mod bootstrap;
mod connect;
mod init;

#[derive(Debug, Clone, Copy)]
#[repr(u8)]
pub enum DatabaseState {
    AWAIT_INIT,
    CONNECTING,
    CONNECTED,
    FAILED,
}

pub struct DB {
    state: DatabaseState,
}

impl DB {
    pub fn is_init() -> bool {
        false
    }

    pub fn init(&mut self) -> DatabaseState {
        self.state = DatabaseState::CONNECTING;

        DatabaseState::CONNECTING
    }
}

pub static DATABASE: DB = DB {
    state: DatabaseState::AWAIT_INIT,
};

impl IntoArma for DatabaseState {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::Number((*self as u8).into())
    }
}

pub fn group() -> Group {
    Group::new()
        .command("connect", connect::connect)
        .command("bootstrap", bootstrap::bootstrap)
}

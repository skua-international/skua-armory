use arma_rs::{Extension, arma};

pub mod database;
mod uuid;

// starts here
#[arma]
fn init() -> Extension {
    Extension::build()
        .command("uuid", uuid::new_uuid_v7)
        .group("database", database::group())
        .finish()
}

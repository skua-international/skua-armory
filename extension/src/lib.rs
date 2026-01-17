use arma_rs::{Extension, arma};

mod uuid;
mod database;

// starts here
#[arma]
fn init() -> Extension {
    Extension::build()
    .group("database", database::group())
        .command("uuid", uuid::new_uuid_v7) // "skua" callExtension ["uuid", []]
        .finish()
}

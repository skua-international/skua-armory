use arma_rs::{Extension, arma};

mod database;
mod editor;
mod uuid;

// starts here
#[arma]
fn init() -> Extension {
    Extension::build()
        .command("descriptionExt", editor::description_ext) // "skua" callExtension ["descriptionExt", [getMissionPath ""]]
        .group("database", database::group())
        .command("uuid", uuid::new_uuid_v7) // "skua" callExtension ["uuid", []]
        .finish()
}

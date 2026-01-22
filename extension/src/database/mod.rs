use {
    crate::database::{bootstrap::bootstrap, db::get_database_state},
    arma_rs::Group,
};

mod bootstrap;
mod db;
mod test_support;
mod tests;
mod types;

/* ============================
 * Command Group
 * ============================ */

pub fn group() -> Group {
    Group::new()
        .command("bootstrap", bootstrap)
        .command("state", get_database_state)
}

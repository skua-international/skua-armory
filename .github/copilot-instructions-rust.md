# Rust Coding Instructions for LLM Agents

This document provides instructions for LLM agents writing Rust code in this repository, specifically for the Arma 3 extension (`extension/` directory).

## 1. Project Overview

This is an Arma 3 extension built using the `arma-rs` crate. It provides:
- A Tokio-based async runtime for database operations
- PostgreSQL database connectivity via `deadpool-postgres`
- Extension commands callable from SQF (Arma scripting language)
- Structured logging via `tracing`

> **Important:** Work in `src/extension_new/` for new development. See the `AGENTS.md` file in that directory for detailed architecture documentation.

## 2. Project Structure

### 2.1 Module Layout

The extension follows a layered architecture with clear separation of concerns:

```
extension/src/extension_new/
├── lib.rs              # Entry point, extension registration
├── AGENTS.md           # Detailed LLM instructions
│
├── core/               # Core infrastructure (no dependencies on other modules)
│   ├── mod.rs          # Exports: RUNTIME, SESSION_ID
│   ├── runtime.rs      # Global Tokio runtime
│   └── session.rs      # Session identifier
│
├── error/              # Error handling (depends on: nothing)
│   ├── mod.rs          # Exports: transient_error, QueryResult, etc.
│   ├── query.rs        # QueryState, QueryResult, QueryError
│   └── db.rs           # DbError for database operations
│
├── domain/             # Domain types (depends on: nothing)
│   ├── mod.rs          # Exports: PlayerId, CampaignId, SessionId
│   └── ids.rs          # Identifier newtypes
│
├── logging/            # Structured logging (depends on: nothing)
│   ├── mod.rs          # Exports: init, group
│   ├── layer.rs        # Tracing layer for Arma callbacks
│   └── commands.rs     # set_level, get_level commands
│
├── database/           # Database connectivity (depends on: core, error)
│   ├── mod.rs          # Exports: get_db, get_client, group
│   ├── pool.rs         # Connection pool management
│   ├── state.rs        # DatabaseState enum
│   ├── schema.rs       # Bootstrap operations
│   ├── commands.rs     # Arma command registration
│   ├── sql.rs          # Embedded SQL constants
│   ├── sql/            # SQL files (symlink)
│   └── tests.rs        # Integration tests
│
└── persistence/        # Game state persistence (depends on: core, error, domain, database)
    ├── mod.rs          # Exports: group, PersistedObject
    ├── types.rs        # Object types for persistence
    └── commands.rs     # save command
```

### 2.2 Dependency Rules

Modules form a directed acyclic graph:
1. `core`, `error`, `domain`, `logging` - Foundation layer (no internal dependencies)
2. `database` - Depends on core and error
3. `persistence` - Depends on all above

**Never create circular dependencies between modules.**

### 2.3 File Naming Conventions

| File | Purpose |
|------|---------|
| `mod.rs` | Module root with public exports |
| `types.rs` | Type definitions for the module |
| `commands.rs` | Arma-callable commands |
| `tests.rs` | Integration tests (cfg(test)) |

## 3. Key Patterns

### 3.1 Global State with Lazy Initialization

Use `LazyLock` for simple sync initialization:

```rust
use std::sync::LazyLock;

pub static RUNTIME: LazyLock<tokio::runtime::Runtime> = LazyLock::new(|| {
    tokio::runtime::Builder::new_multi_thread()
        .enable_all()
        .build()
        .expect("failed to initialize tokio runtime")
});
```

Use `tokio::sync::OnceCell` for async initialization:

```rust
use tokio::sync::OnceCell;

static DATABASE: OnceCell<Database> = OnceCell::const_new();

pub async fn get_db() -> Result<&'static Database, tokio_postgres::Error> {
    DATABASE.get_or_try_init(Database::init_from_env).await
}
```

### 3.2 Database Access

**Always prefer `get_client()` for database operations:**

```rust
use crate::database::get_client;

async fn do_query() -> Result<(), DbError> {
    let client = get_client().await?;
    client.execute("SELECT 1", &[]).await?;
    Ok(())
}
```

Use `get_db()` only when you need access to database state:

```rust
let db = get_db().await?;
db.set_state(DatabaseState::ConnectedInit);
```

### 3.3 Async Commands with Callbacks

For long-running operations, spawn onto the runtime and use callbacks:

```rust
pub fn my_command(ctx: Context, arg: String) -> QueryState {
    RUNTIME.spawn(async move {
        let result = do_work(&arg).await;
        let _ = ctx.callback_data("skua:module", "my_command", result);
    });

    QueryState::Processing
}
```

### 3.4 Error Handling

Use `transient_error()` for recoverable errors that should be reported to Arma:

```rust
use crate::error::transient_error;

async fn do_work() -> QueryResult {
    let client = get_client().await.map_err(|e| {
        return transient_error("Failed to get client", e);
    })?;
    
    QueryResult::done()
}
```

### 3.5 Command Groups

Each feature module exposes a `group()` function:

```rust
// In commands.rs
use arma_rs::Group;

pub fn group() -> Group {
    Group::new()
        .command("action1", action1)
        .command("action2", action2)
}
```

Register in `lib.rs`:

```rust
.group("module_name", module::group())
```

## 4. Type Definitions

### 4.1 Arma Interop Types

Use `arma_rs` derive macros for types crossing the FFI boundary:

```rust
use arma_rs::{FromArma, IntoArma};

#[derive(Debug, FromArma, IntoArma)]
pub struct QueryError {
    #[arma(to_string)]
    pub code: String,
    #[arma(to_string)]
    pub message: String,
    #[arma(to_string)]
    pub location: String,
}
```

### 4.2 Newtype Pattern for Identifiers

Always use newtypes for domain identifiers:

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, FromArma, Serialize, Deserialize)]
pub struct PlayerId(u64);

impl From<u64> for PlayerId {
    fn from(value: u64) -> Self {
        PlayerId(value)
    }
}
```

### 4.3 Atomic State Wrappers

For thread-safe state with enum values:

```rust
use std::sync::atomic::{AtomicU8, Ordering};

#[derive(Debug, Clone, Copy, PartialEq)]
#[repr(u8)]
pub enum DatabaseState {
    AwaitConnect = 0,
    ConnectedInit = 1,
    ConnectedAwaitInit = 2,
    Failed = 3,
}

pub struct AtomicDatabaseState {
    inner: AtomicU8,
}

impl AtomicDatabaseState {
    pub fn load(&self) -> DatabaseState {
        match self.inner.load(Ordering::Relaxed) {
            0 => DatabaseState::AwaitConnect,
            1 => DatabaseState::ConnectedInit,
            2 => DatabaseState::ConnectedAwaitInit,
            _ => DatabaseState::Failed,
        }
    }

    pub fn store(&self, state: DatabaseState) {
        self.inner.store(state as u8, Ordering::Relaxed);
    }
}
```

## 5. Logging & Instrumentation

### 5.1 Use `tracing` Macros

```rust
use tracing::{info, error, debug, warn, instrument};

info!("Database connected");
error!(error = %e, "Failed to execute query");
debug!(player_id = %id, action = "join", "Player joined");
```

### 5.2 Instrument Functions

Use `#[instrument]` for automatic span creation:

```rust
#[instrument(level = "debug", name = "bootstrap_master")]
async fn bootstrap_master(client: &Client) -> Result<(), QueryResult> {
    // Entry/exit automatically logged
}

#[instrument(level = "info", skip(ctx))]  // Skip non-Debug args
pub fn bootstrap(ctx: Context, campaign_id: String) -> QueryState {
    // ...
}
```

## 6. SQL Management

### 6.1 Embed SQL at Compile Time

Organize SQL in a dedicated `sql.rs` module:

```rust
// src/database/sql.rs
pub mod master {
    pub const SCHEMA: &str = include_str!("sql/000_master_schema.sql");
    pub const RANKS: &str = include_str!("sql/010_master_ranks.sql");
}

pub mod campaign {
    pub const SCHEMA: &str = include_str!("sql/100_campaign_schema.sql");
}
```

### 6.2 SQL File Naming Convention

Use numbered prefixes for execution order:
- `000-099`: Master schema (global, shared)
- `100-199`: Campaign schema (per-campaign)
- `200-299`: Session schema (ephemeral)

```
sql/
├── 000_master_schema.sql
├── 010_master_ranks.sql
├── 020_master_player_info.sql
├── 100_campaign_schema.sql
└── 200_session_schema.sql
```

### 6.3 Template Placeholders

Use `${variable}` for dynamic schema names:

```sql
CREATE SCHEMA IF NOT EXISTS skua_campaign_${campaign_id};
```

Replace at runtime:
```rust
let sql = campaign::SCHEMA.replace("${campaign_id}", &schema_key);
```

## 7. Testing

### 7.1 Integration Tests Required

**Every new command must have integration tests:**

```rust
#[test]
fn bootstrap_is_idempotent() {
    let _rt = enter_test_runtime();
    init_logging();

    let extension = Extension::build()
        .group("database", crate::database::group())
        .finish()
        .testing();

    // First call
    call_bootstrap(&extension, &key);
    assert_eq!(wait_for_result(&extension), QueryState::Done);

    // Second call must also succeed
    call_bootstrap(&extension, &key);
    assert_eq!(wait_for_result(&extension), QueryState::Done);
}
```

### 7.2 Unit Tests for Pure Functions

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sanitize_key_replaces_hyphens() {
        assert_eq!(sanitize_key("my-key"), Ok("my_key".to_string()));
    }
}
```

### 7.3 Running Tests

```bash
# Start database
cd database && docker-compose up -d

# Run all tests
cargo test

# Run with output
cargo test -- --nocapture

# Run specific test
cargo test bootstrap_is_idempotent
```

## 8. Code Style

### 8.1 Imports

Standard grouped style preferred:

```rust
use std::collections::HashMap;
use std::sync::OnceLock;

use arma_rs::{Context, Extension, Group};
use tokio_postgres::Client;
use tracing::{error, info, instrument};

use crate::core::RUNTIME;
use crate::error::{transient_error, QueryResult};
```

### 8.2 Visibility

- `pub` - Public API only
- `pub(crate)` - Shared within crate
- Private by default

### 8.3 Documentation

Document public items:

```rust
/// Get a database client directly from the connection pool.
///
/// This is the preferred way to get a database connection for most operations.
/// Use `get_db()` only when you need access to the `Database` struct itself.
pub async fn get_client() -> Result<deadpool_postgres::Client, DbError> {
    // ...
}
```

## 9. Things to Avoid

- **Blocking the async runtime**: No `std::thread::sleep` in async code
- **Unwrap in production**: Use `expect()` with messages or proper error handling
- **Circular dependencies**: Maintain the module dependency DAG
- **Large monolithic files**: Split into focused modules
- **Ignoring errors**: Always log or propagate
- **Magic numbers**: Use constants or configuration
- **Hardcoded config**: Use environment variables

## 10. Adding New Features

### 10.1 New Command

1. Add function in `commands.rs`
2. Register in module's `group()` function
3. Add integration test

### 10.2 New Module

1. Create directory under `src/extension_new/`
2. Create `mod.rs` with public exports
3. Add `pub mod module_name;` in `lib.rs`
4. Register command group in `init()` if applicable

### 10.3 New Persistence Type

1. Add struct in `persistence/types.rs`
2. Derive `FromArma`, `Serialize`, `Deserialize`
3. Add variant to `PersistedObject` enum
4. Implement handler in `commands.rs`

## 11. Dependencies

| Crate | Purpose |
|-------|---------|
| `arma-rs` | Arma 3 extension FFI |
| `tokio` | Async runtime |
| `deadpool-postgres` | Connection pooling |
| `tokio-postgres` | Async PostgreSQL client |
| `tracing` | Structured logging |
| `serde` / `serde_json` | Serialization |
| `uuid` | UUID generation (v7 for time-ordered) |
| `regex` | Input validation |

When adding dependencies:
1. Prefer well-maintained crates
2. Enable only needed features
3. Consider binary size (game extension)

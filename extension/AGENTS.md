# AGENTS.md - LLM Instructions for Skua Extension

This document provides instructions for LLM agents working on the Skua Arma 3 extension.

## Project Overview

Skua is an Arma 3 extension providing database persistence for missions. It's built with:
- **Rust** - Core extension code
- **arma-rs** - Arma 3 extension framework
- **tokio** - Async runtime for non-blocking operations
- **deadpool-postgres** - PostgreSQL connection pooling
- **tracing** - Structured logging

## Architecture

```
src/extension_new/
├── lib.rs              # Entry point, extension registration
├── core/               # Core infrastructure
│   ├── mod.rs
│   ├── runtime.rs      # Global Tokio runtime (RUNTIME)
│   └── session.rs      # Session ID (SESSION_ID)
├── error/              # Error handling
│   ├── mod.rs          # transient_error() helper
│   ├── query.rs        # QueryState, QueryResult, QueryError
│   └── db.rs           # DbError for database operations
├── domain/             # Domain types
│   ├── mod.rs
│   └── ids.rs          # PlayerId, CampaignId, SessionId
├── logging/            # Structured logging
│   ├── mod.rs
│   ├── layer.rs        # Tracing layer for Arma callbacks
│   └── commands.rs     # set_level, get_level commands
├── database/           # Database connectivity
│   ├── mod.rs
│   ├── pool.rs         # Connection pool (get_db, get_client)
│   ├── state.rs        # DatabaseState enum
│   ├── schema.rs       # Bootstrap operations
│   ├── commands.rs     # Arma commands
│   ├── sql.rs          # Embedded SQL constants
│   ├── sql/            # SQL files (symlink to ../database/sql)
│   └── tests.rs        # Integration tests
└── persistence/        # Game state persistence
    ├── mod.rs
    ├── types.rs        # PersistedObject, ObjectData, etc.
    └── commands.rs     # save command
```

## Key Patterns

### 1. Module Organization

Each feature module follows this structure:
- `mod.rs` - Public exports and module documentation
- `types.rs` - Type definitions (if needed)
- `commands.rs` - Arma-callable commands
- Internal implementation files

### 2. Global State

Use `LazyLock` for simple globals, `OnceCell` for async initialization:

```rust
// Simple sync initialization
pub static RUNTIME: LazyLock<Runtime> = LazyLock::new(|| { ... });

// Async initialization
static DATABASE: OnceCell<Database> = OnceCell::const_new();

pub async fn get_db() -> Result<&'static Database, Error> {
    DATABASE.get_or_try_init(Database::init).await
}
```

### 3. Async Commands

Commands that perform I/O spawn onto the global runtime and use callbacks:

```rust
pub fn my_command(ctx: Context, arg: String) -> QueryState {
    RUNTIME.spawn(async move {
        let result = do_work(&arg).await;
        let _ = ctx.callback_data("skua:module", "my_command", result);
    });
    
    QueryState::Processing
}
```

### 4. Error Handling

Use `transient_error()` for recoverable errors that should be reported to Arma:

```rust
use crate::error::transient_error;

async fn do_work() -> QueryResult {
    let client = get_client().await.map_err(|e| {
        transient_error("Failed to get client", e)
    })?;
    
    // ... work ...
    
    QueryResult::done()
}
```

### 5. Database Access

Prefer `get_client()` for most operations:

```rust
// Preferred - gets a pooled connection directly
let client = get_client().await?;

// Only when you need DB state management
let db = get_db().await?;
db.set_state(DatabaseState::ConnectedInit);
```

### 6. Command Groups

Organize related commands into groups:

```rust
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

## Adding New Features

### 1. New Command

1. Add function in appropriate `commands.rs`
2. Register in the module's `group()` function
3. Document the Arma calling convention

### 2. New Module

1. Create directory under `src/extension_new/`
2. Create `mod.rs` with public exports
3. Add `pub mod module_name;` in `lib.rs`
4. If it has commands, register the group in `init()`

### 3. New Persistence Type

1. Add struct in `persistence/types.rs`
2. Derive `FromArma`, `Serialize`, `Deserialize`
3. Add variant to `PersistedObject` enum
4. Implement handler in `commands.rs`

## SQL Schema

SQL files are in `database/sql/` with naming convention:
- `000-099`: Master schema (shared across all)
- `100-199`: Campaign schema (per campaign)
- `200-299`: Session schema (per session)

Templates use `${campaign_id}` or `${session_id}` placeholders.

## Testing

Run tests with a local PostgreSQL instance:

```bash
# Start database
cd database && docker-compose up -d

# Run tests
cd extension && cargo test
```

## Common Mistakes to Avoid

1. **Don't block the runtime** - All I/O must be async
2. **Don't forget callbacks** - Arma needs results via callback_data
3. **Don't leak connections** - Use the pool, don't hold connections long
4. **Don't use unwrap() in commands** - Return errors to Arma gracefully
5. **Don't create infinite loops** - Arma extension runs in game thread

## Arma Calling Convention

From SQF:
```sqf
// Sync command
private _result = "skua" callExtension ["command_name", [arg1, arg2]];

// Async command (returns immediately, result via callback)
"skua" callExtension ["database:bootstrap", [campaign_id, world]];
// Result arrives in extensionCallback
```

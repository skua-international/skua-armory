// parseNumber is slower than comparing the string directly, so we'll just deal with it
// these should match the Rust extension code
#define DATABASESTATE_CONNECTING ("0")
#define DATABASESTATE_CONNECTED  ("1")
#define DATABASESTATE_FAILED     ("2")

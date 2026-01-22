# Extension

Shit that can't be done or is extremely inconvenient to do inside Arma, like generating a UUID or talking to the database.

## Building

`cd` into this directory.

### For Linux (targeting the Dedicated Server)

`cargo build --release` should be all you need

### For Windows

- Install cargo-xwin: `cargo install xwin --locked`
- Add the target: `rustup target add x86_64-pc-windows-msvc`
- Build: `cargo xwin build --release --target x86_64-pc-windows-msvc`

### The easy way
- Run `install_deps.sh`
- Run `build.sh`

## After building

Move the compiled library (`skua.dll` or `libskua.so`) to the root of the repository and add the _x64 suffix:
```bash
mv target/x86_64-pc-windows-msvc/release/skua.dll ./../skua_x64.dll # for Windows

mv target/x86_64-unknown-linux-gnu/release/libskua.so ./../skua_x64.so # for Linux
```

## Running tests

```bash
export DATABASE_HOST=127.0.0.1
export DATABASE_PORT=55432
export DATABASE_USER=postgres
export DATABASE_PASSWORD=postgres
export DATABASE_NAME=postgres

cargo test -- --test-threads=1
```
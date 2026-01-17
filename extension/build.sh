#!/bin/bash

echo "Building binaries for Windows and Linux"

echo "Building Linux"
cross build --target x86_64-unknown-linux-gnu --release

echo "Building Windows"
cargo xwin build --release --target x86_64-pc-windows-msvc

echo "Moving compiled binaries to repository root"

mv target/x86_64-pc-windows-msvc/release/skua.dll ./../skua_x64.dll # for Windows

mv target/x86_64-unknown-linux-gnu/release/libskua.so ./../skua_x64.so # for Linux
#!/bin/bash

# Check for DEBUG_BUILD environment variable
# If debug, build without --release flag
FLAGS="--release"
if [ "$DEBUG_BUILD" = "1" ]; then
    echo "Debug build detected, building without --release flag"
    FLAGS=""
else 
    echo "Release build detected, building with --release flag"
fi

PWD_DIR=$(pwd)
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT/extension" || exit 1

echo "Building binaries for Windows and Linux"

echo "Building Linux"
cross build --target x86_64-unknown-linux-gnu $FLAGS

echo "Building Windows"
cargo xwin build --target x86_64-pc-windows-msvc $FLAGS

echo "Moving compiled binaries to repository root"

echo "Repository root found at: $REPO_ROOT"

mv target/x86_64-pc-windows-msvc/release/skua.dll "$REPO_ROOT/skua_x64.dll" # for Windows

mv target/x86_64-unknown-linux-gnu/release/libskua.so "$REPO_ROOT/skua_x64.so" # for Linux

cd "$PWD_DIR" || exit 1
#!/bin/bash

echo "Installing cross for cross-compilation"
cargo install cross

echo "Installing Windows toolchian dependencies"
rustup target add x86_64-pc-windows-msvc
cargo install xwin --locked
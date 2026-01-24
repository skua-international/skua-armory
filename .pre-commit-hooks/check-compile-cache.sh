#!/usr/bin/env bash
# Check for uncommented #define DISABLE_COMPILE_CACHE in addons/

set -e

# Search for uncommented DISABLE_COMPILE_CACHE defines
# Pattern matches lines that start with optional whitespace, then #define DISABLE_COMPILE_CACHE
# This excludes lines that start with // (commented out)
matches=$(grep -rn '^[[:space:]]*#define[[:space:]]\+DISABLE_COMPILE_CACHE' --include="*.hpp" addons/ 2>/dev/null || true)

if [ -n "$matches" ]; then
    echo "ERROR: Found uncommented #define DISABLE_COMPILE_CACHE"
    echo "Please comment these out before committing:"
    echo "$matches"
    exit 1
fi

exit 0

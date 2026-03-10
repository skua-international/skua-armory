#!/bin/bash
# Check for uncommented debug macros in source files

echo "Checking for uncommented debug macros..."
ERRORS=0

# Find uncommented #define DEBUG_MODE_FULL (only at start of line, not inside #ifdef blocks)
if grep -rn --include="*.cpp" --include="*.hpp" --include="*.sqf" -E '^#define\s+DEBUG_MODE_FULL' .; then
  echo "::error::Found uncommented #define DEBUG_MODE_FULL"
  ERRORS=$((ERRORS + 1))
fi

# Find uncommented #define DISABLE_COMPILE_CACHE
if grep -rn --include="*.cpp" --include="*.hpp" --include="*.sqf" -E '^#define\s+DISABLE_COMPILE_CACHE' .; then
  echo "::error::Found uncommented #define DISABLE_COMPILE_CACHE"
  ERRORS=$((ERRORS + 1))
fi

# Find uncommented #define ENABLE_PERFORMANCE_COUNTERS
if grep -rn --include="*.cpp" --include="*.hpp" --include="*.sqf" -E '^#define\s+ENABLE_PERFORMANCE_COUNTERS' .; then
  echo "::error::Found uncommented #define ENABLE_PERFORMANCE_COUNTERS"
  ERRORS=$((ERRORS + 1))
fi

if [ $ERRORS -gt 0 ]; then
  echo "::error::Found $ERRORS debug macro issue(s). Please comment out or remove debug macros before merging."
  exit 1
fi

echo "No uncommented debug macros found."

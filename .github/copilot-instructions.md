# SQF Coding Instructions for LLM Agents

This document provides instructions for LLM agents writing SQF code (Arma 3 scripting language).

## 1. Code Structure

### 1.1 File Header
Every function file must include a header comment block:

```sqf
/*
 * Author: [Author Name]
 * [Brief description of what the function does]
 *
 * Arguments:
 * 0: Description <TYPE>
 * 1: Optional argument <TYPE> (default: value)
 *
 * Return Value:
 * Description <TYPE>
 *
 * Example:
 * [player, true] call prefix_component_fnc_functionName
 *
 * Public: [Yes/No]
 */
```

### 1.2 Type Annotations
Use UPPERCASE types in headers: `OBJECT`, `NUMBER`, `STRING`, `BOOL`, `ARRAY`, `CODE`, `CONTROL`, `DISPLAY`, `CONFIG`, `ANY`, `SIDE`, `GROUP`, `HASHMAP`, `NAMESPACE`, `NIL`.

- Multiple types: `<STRING or CODE>`
- Array of same type: `<ARRAY of NUMBERs>`
- Optional with default: `<BOOL> (default: true)`
- No arguments/return: `None`

## 2. Variable Naming & Declaration

### 2.1 Private Variables
- Always declare private variables with the `private` keyword
- Use descriptive names: `_velocity` not `_v`

```sqf
// Good
private _targetPosition = getPos player;

// Bad
_pos = getPos player;
```

### 2.2 Parameters
Always use `params` or `param` to retrieve function parameters:

```sqf
params ["_unit", "_weapon", ["_optional", true]];
// or
private _unit = param [0, objNull, [objNull]];
```

### 2.3 Variable Scope
Declare variables at the smallest feasible scope and initialize with meaningful values.

## 3. Code Style

### 3.1 Braces
- Opening brace on same line as statement
- Closing brace on its own line, aligned with statement
- `else` on same line as closing brace

```sqf
if (alive player) then {
    player setDamage 0.5;
} else {
    hint "Player is dead";
};
```

### 3.2 Indentation
- Use 4 spaces (no tabs)
- No trailing whitespace

### 3.3 Array Notation
Always use spaces between array elements:

```sqf
// Good
private _pos = [0, 0, 0];
params ["_unit", "_target"];

// Bad
private _pos = [0,0,0];
```

### 3.4 Comments
- Use `//` for inline comments
- Use `/* */` for larger blocks
- Comment complex/critical code sections
- Avoid obvious comments

```sqf
// Find unit with highest damage (useful comment)
// Loop through array (useless comment - don't do this)
```

## 4. Control Flow

### 4.1 Conditionals
Wrap conditions in brackets. Both `!` placements are valid:

```sqf
if (_value) then { };
if (!_value) then { };
if !(_value && _otherValue) then { };
```

### 4.2 Loops
Prefer `for` loop syntax:

```sqf
// Good
for "_i" from 0 to 10 do {
    hint str _i;
};

// Avoid when possible
for [{_i = 0}, {_i < 10}, {_i = _i + 1}] do { };
```

### 4.3 Avoid Infinite Loops
Never write infinite `while` loops:

```sqf
// NEVER do this
while {true} do { };
```

## 5. Performance Best Practices

### 5.1 Array Operations
Use `pushBack` for single elements, `append` for multiple:

```sqf
// Good
_array pushBack _element;
_array append [1, 2, 3];

// Bad
_array = _array + [_element];
_array set [count _array, _element];
```

### 5.2 Vehicle Creation
Use array syntax and spawn at `[0, 0, 0]` then move:

```sqf
// Good - fast
private _vehicle = createVehicle [_type, [0, 0, 0], [], 0, "NONE"];
_vehicle setPosATL _targetPos;

// Bad - slow (searches for empty space)
private _vehicle = createVehicle [_type, _targetPos, [], 0, "NONE"];
```

### 5.3 Empty Array Check
Use `isEqualTo` for checking empty arrays:

```sqf
if (_array isEqualTo []) then { };
```

### 5.4 getVariable
Always provide a default value or handle nil:

```sqf
// Good
private _value = _obj getVariable ["varName", 0];

// Good (with nil check)
private _value = _obj getVariable "varName";
if (isNil "_value") exitWith {};

// Bad
private _value = _obj getVariable "varName";
if (isNil "_value") then { _value = 0 };
```

### 5.5 Avoid Scheduled Execution
Avoid `spawn` and `execVM` - prefer unscheduled execution with event handlers or CBA functions.

## 6. Magic Numbers
Never use unexplained numeric constants. Define them:

```sqf
#define RELOAD_TIME 3
#define MAX_RANGE 500

// Good
if (_distance < MAX_RANGE) then { };

// Bad
if (_distance < 500) then { };
```

## 7. Return Values
- Functions must return meaningful values or `nil`
- No unreachable code after return statements

```sqf
if (_condition) exitWith { true };
false // implicit return
```

## 8. Event Handlers
When adding event handlers, use short code blocks that call functions:

```sqf
// Good
player addEventHandler ["Fired", {call TAG_fnc_handleFired}];

// Bad (slow with large functions)
player addEventHandler ["Fired", TAG_fnc_handleFired];
```

## 9. Common Patterns

### 9.1 Finding in Array
```sqf
private _index = _array findIf {_x == _searchValue};
if (_index == -1) exitWith { /* not found */ };
```

### 9.2 Filtering Array
```sqf
private _filtered = _array select {alive _x};
```

### 9.3 Safe Object Check
```sqf
if (isNull _object) exitWith {};
if (!alive _unit) exitWith {};
```

### 9.4 Distance Check
```sqf
if (_unit distance _target > 100) exitWith {};
```

## 10. Things to Avoid

- Tabs (use 4 spaces)
- Trailing whitespace
- Magic numbers
- Commented-out code
- Global variables for passing data between functions
- Unnecessary temporary variables
- Functions longer than 250 lines
- `waitUntil` command (use CBA alternatives)
- Infinite loops
- Undeclared private variables

#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Tell the extension to send a heartbeat signal to keep the database session alive.
 *
 * Return Value:
 * None.
 *
 * Example:
 * call skua_persistence_fnc_heartbeat;
 *
 * Public: No
 */

#define HEARTBEAT_INTERVAL 10 // seconds

if (!GVAR(enabled)) exitWith {};

if (!GVAR(ready)) exitWith {
    GVAR(runAfterReady) pushBack [FUNC(heartbeat), _this];
};

INFO("Heartbeat!");

private _fullReturn = ("skua" callExtension ["database:heartbeat", [GVAR(sessionId)]]);
private _state = parseNumber (_fullReturn select 0);
if (_state != 0) then {
    ERROR_1("Database heartbeat call failed with state: %1",_state);
    _fullReturn
};

[FUNC(heartbeat), _this, HEARTBEAT_INTERVAL] call CBA_fnc_waitAndExecute;

_state

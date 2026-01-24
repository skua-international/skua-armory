#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Call the extension to bootstrap the database and start a watchdog timer.
 *
 * Return Value:
 * None.
 *
 * Example:
 * call skua_persistence_fnc_databaseBootstrap;
 *
 * Public: No
 */

#define DATABASE_READY_TIMEOUT 60 // seconds

if (!GVAR(settingsLoaded)) exitWith {
    GVAR(runAfterSettingsLoaded) pushBack [FUNC(bootstrap), _this];
};

if (!GVAR(enabled)) exitWith {};

if (GVAR(location) == PERSISTENCE_LOCATION_LOCAL) exitWith {
    [QGVAR(ready)] call CBA_fnc_globalEventJIP;
};

private _state = parseNumber (("skua" callExtension ["database:bootstrap", [GVAR(key), GVAR(sessionId), worldName]]) select 0);
if (_state != 0) exitWith {
    ERROR_1("Database bootstrap call failed with state: %1",_state);
    [QGVAR(noDatabase)] remoteExec ["endMission", 0, true];
};

GVAR(databaseState) = _state;
GVAR(bootstrapStartTime) = diag_tickTime;
[{
    if (!GVAR(enabled)) exitWith {};
    if (GVAR(ready)) exitWith {};

    ERROR("Database bootstrap timed out.");
    [QGVAR(noDatabase)] remoteExec ["endMission", 0, true];
}, nil, DATABASE_READY_TIMEOUT] call CBA_fnc_waitAndExecute;

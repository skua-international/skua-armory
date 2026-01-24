#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Kill the watchdog timer started during bootstrap and mark the database as initialized.
 *
 * Arguments:
 * 0: Extension name (in theory, extension may report something else) <STRING>
 * 1: Function name (arbitrary, defined by extension) <STRING>
 * 2: Data: returned data from the extension and error codes. <STRING>
 *
 * Return Value:
 * None.
 *
 * Example:
 * ["skua:database", "bootstrap", "extension_data"] call skua_persistence_fnc_extCallback_database;
 *
 * Public: No
 */
params ["", "", "_data"];
(parseSimpleArray _data) params ["_state", ["_error", []]]; // number, array'd hashmap
// _error = createHashMapFromArray _error; could be done here but we just log it and don't do anything with it
// so the output out be the same either way

GVAR(databaseState) = _state;

INFO_2("Database bootstrap completed with state: %1 after %2 seconds",_state,diag_tickTime - GVAR(bootstrapStartTime));

if (_error isNotEqualTo []) exitWith {
    ERROR_1("Database bootstrap failed with error: %1",_error);
    [QGVAR(noDatabase)] remoteExec ["endMission", 0, true];
};

GVAR(ready) = true;
[QGVAR(ready)] call CBA_fnc_globalEventJIP;

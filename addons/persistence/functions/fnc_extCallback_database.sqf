#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Fired from Mission EventHandler ExtensionCallback added at PreInit.
 * Handles extension callbacks for "skua:database" and routes to appropriate functions.
 *
 * Arguments:
 * 0: Extension name (in theory, extension may report something else) <STRING>
 * 1: Function name (arbitrary, defined by extension) <STRING>
 * 2: Data: returned data from the extension and error codes. <ARRAY>
 *
 * Return Value:
 * None.
 *
 * Example:
 * ["skua:database", "connect", ["0", 0, 0]] call skua_persistence_fnc_extCallback_database;
 *
 * Public: No
 */
params ["_name", "_function", "_data"];

if (_name != "skua:database") exitWith {};

switch (_function) do {
    case "connect": {_data call FUNC(onDatabaseConnectReturn)};
    default {ERROR_1("Unhandled extension callback function: %1",_function)};
};

#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Fired from Mission EventHandler ExtensionCallback added at PreInit.
 * Handles extension callbacks for "skua:*" and routes to appropriate functions.
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
 * ["skua:database", "connect", ["0", 0, 0]] call skua_persistence_fnc_handleExtensionCallback;
 *
 * Public: No
 */
params ["_name", "_function", "_data"];

if !("skua" in _name || _name == "skua_ext_log") exitWith {}; // We don't care.

private _actualFunction = format ["%1:%2", (_name splitString ":" select 1), _function];
INFO_1("Handling extension function: %1",_actualFunction);

if (!GVAR(settingsLoaded)) exitWith {
    GVAR(runAfterSettingsLoaded) pushBack [FUNC(handleExtensionCallback), _this];
};

switch (_actualFunction) do {
    case "database:bootstrap": LINKFUNC(handleBootstrap);
    case "player:loadData": LINKFUNC(handleLoadPlayerData);
    default {ERROR_1("Unhandled extension callback function: %1",_actualFunction)};
};

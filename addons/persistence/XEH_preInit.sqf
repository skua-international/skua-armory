#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

if (!isMultiplayer) exitWith {};

if (hasInterface) then {
    [QGVAR(ready), {
        player call FUNC(request_loadPlayerData);
    }] call CBA_fnc_addEventHandler;
};

if (!isServer) exitWith {};

// Pre-Init only runs on the server

GVAR(ready) = false;
GVAR(runAfterSettingsLoaded) = [];
GVAR(settingsLoaded) = false;
GVAR(namespace) = false call CBA_fnc_createNamespace;

addMissionEventHandler ["ExtensionCallback", LINKFUNC(handleExtensionCallback)];
INFO("Added ExtensionCallback event handler for database extension.");

["CBA_settingsInitialized", {
    call FUNC(loadSettings);
}] call CBA_fnc_addEventHandler;

GVAR(runAfterReady) = [];
[QGVAR(ready), {
    GVAR(ready) = true;
    {
        _x params ["_func", "_args"];
        _args call _func;
    } forEach GVAR(runAfterReady);
    GVAR(runAfterReady) = [];
}] call CBA_fnc_globalEventJIP;

//call FUNC(bootstrap);

ADDON = true;

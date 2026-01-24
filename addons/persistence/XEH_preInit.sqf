#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

if (hasInterface) then {
    [QGVAR(ready), {
        player call FUNC(request_loadPlayerData);
    }] call CBA_fnc_addEventHandler;
};

if (!isServer) exitWith {};

// Pre-Init only runs on the server

// sessionId is used to identify this particular mission session.
// the sessionId may be used to restore position/medical state upon player reconnect without a mission restart
GVAR(sessionId) = call EFUNC(common,createUUIDv7);
GVAR(ready) = false;
GVAR(runAfterSettingsLoaded) = [];
GVAR(settingsLoaded) = false;

INFO_1("Generated mission session ID: %1",GVAR(sessionId));
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

call FUNC(bootstrap);
call FUNC(heartbeat);

[QGVAR(saveObject), LINKFUNC(saveObject)] call CBA_fnc_addEventHandler;
[QGVAR(saveUnit), LINKFUNC(saveUnit)] call CBA_fnc_addEventHandler;


ADDON = true;

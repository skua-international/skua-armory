#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

//#include "initSettings.inc.sqf"

GVAR(key) = "prod"; // Add setting

if (isServer) then {
    GVAR(saveAllObjects) = false; // save objects even if they weren't marked for saving
    addMissionEventHandler ["ExtensionCallback", {
        params ["_name", "_function", "_data"];
        if (_name != "skua:database") exitWith {};

        systemChat format ["extensionCallback: %1: %2", _function, _data];
    }];
};


ADDON = true;

#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(allArsenals) = createHashMap;

// Keep track of the mission's arsenals
[QACEGVAR(arsenal,boxInitialized), {
    params ["_box"];

    GVAR(allArsenals) set [_box, nil];
}] call CBA_fnc_addEventHandler;

ADDON = true;

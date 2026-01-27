#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (!isMultiplayer) exitWith {};

if (hasInterface) then {
    [QGVAR(deserializeMedical), {
        _this call ACEFUNC(medical,deserializeState);
    }] call CBA_fnc_addEventHandler;
};


if (isServer) then {
    GVAR(namespace) = createHashMap;
    [QGVAR(loadPlayer), LINKFUNC(loadPlayer)] call CBA_fnc_addEventHandler;

    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit", "", "_uid", "_name"];

        [_unit, _uid] call FUNC(savePlayer);
    }];
};

ADDON = true;

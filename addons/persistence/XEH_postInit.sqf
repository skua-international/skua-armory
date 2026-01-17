#include "script_component.hpp"

if (!isServer) exitWith {};

[QGVAR(saveObject), LINKFUNC(saveObject_position)] call CBA_fnc_addEventHandler;
[QGVAR(saveUnit), LINKFUNC(saveUnit_loadout)] call CBA_fnc_addEventHandler;
[QGVAR(saveUnit), LINKFUNC(saveUnit_medical)] call CBA_fnc_addEventHandler;

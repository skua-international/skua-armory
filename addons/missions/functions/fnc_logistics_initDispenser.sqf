#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Add logistics action menu to an object.
 *
 * Arguments:
 * 0: Object to add actions to <OBJECT>
 *
 * Return Value:
 * None. <NONE>
 *
 * Example:
 * [object] call skua_missions_fnc_logistics_initDispenser;
 *
 * Public: No
 */

#define INTERACTION_DISTANCE 8

params ["_dispenser"];
TRACE_1("fnc_logistics_initDispenser",_this);

private _menu = [
    QGVAR(logisticsMenu),
    "Logistics",
    "\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa",
    {true}, // statement
    {true}, // condition
    {_target call FUNC(makeLogisticsActions)} // children
] call ACEFUNC(interact_menu,createAction);

[_dispenser, 0, ["ACE_MainActions"], _menu] call ACEFUNC(interact_menu,addActionToObject);

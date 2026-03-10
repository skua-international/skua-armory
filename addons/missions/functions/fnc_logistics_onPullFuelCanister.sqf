#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Handles pulling a fuel canister: sets fuel cargo to 0.
 *
 * Arguments:
 * 0: Object <OBJECT>
 *
 * Return Value:
 * None.
 *
 * Example:
 * [object] call skua_missions_fnc_logistics_onPullFuelCanister;
 *
 * Public: No
 */

params ["_object"];
TRACE_1("fnc_logistics_onPullFuelCanister",_this);

[{
    [_this, 0] call ACEFUNC(refuel,setFuel);
}, _object] call CBA_fnc_execNextFrame;


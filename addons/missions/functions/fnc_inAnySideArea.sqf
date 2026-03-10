#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Checks if unit is any of side's areas.
 *
 * Arguments:
 * 0: Unit to check <OBJECT>
 * 1: Hashmap with side areas to check <HASHMAP of ARRAY>
 *
 * Return Value:
 * In any area <BOOL>
 *
 * Example:
 * [unit, skua_missions_arsenalAreas] call skua_missions_fnc_inAnyGroupArea
 *
 * Public: No
 */

params ["_unit", "_areas"];
TRACE_1("fnc_inAnyGroupArea",_this);

private _side = side group _unit;

(_areas get _side) findIf {_unit inArea _x} != -1 // return

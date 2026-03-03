#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Check whether the unit can open the Base Arsenal. The Base Arsenal is accessible while inside an Arsenal Area,
 * and is shared between all Arsenal Areas on the map.
 *
 * Arguments:
 * 0: The unit to check <OBJECT>
 *
 * Return Value:
 * Can open <BOOL>
 *
 * Example:
 * call skua_missions_fnc_canOpenBaseArsenal;
 *
 * Public: No
 */
params ["_unit"];

private _side = side group _unit;

private _areas = GVAR(arsenalAreas) get _side;

_areas findIf {_unit inArea _x} != -1 // return

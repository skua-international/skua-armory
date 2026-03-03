#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Opens the Base Arsenal. The Base Arsenal is accessible while inside an Arsenal Area,
 * and is shared between all Arsenal Areas on the map.
 *
 * Arguments:
 * 0: The unit to open the base arsenal for <OBJECT>
 *
 * Return Value:
 * <NONE>
 *
 * Example:
 * call skua_missions_fnc_openBaseArsenal;
 *
 * Public: No
 */
params ["_unit"];

private _unitSide = side group _unit;
private _arsenal = GVAR(baseArsenals) get _unitSide;
if (!alive _arsenal) exitWith {systemChat "Base Arsenal not set, deleted, or destroyed."};

[_arsenal, _unit, false] call ACEFUNC(arsenal,openBox);

#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Handles Add Arsenal Area module.
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 *
 * Return Value:
 * <NONE>
 *
 * Example:
 * [logic] call skua_missions_fnc_moduleArsenalAddArea;
 *
 * Public: No
 */

params ["_logic"];
TRACE_1("fnc_moduleArsenalAddArea",_this);

private _side = _logic getVariable ["Side", 1];
_side = switch (_side) do {
    case (1): {west};
    case (2): {east};
    case (3): {resistance};
    case (4): {civilian};
    default {sideUnknown};
};

(_logic getVariable ["objectArea", [0, 0, 0, false, 0]]) params ["_xRadius", "_yRadius", "", "_isRectangle", "_zRadius"];

[_side, _logic, _xRadius, _yRadius, _isRectangle, _zRadius] call FUNC(createArsenalArea);

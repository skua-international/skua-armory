#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Handles Set Reference module.
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 *
 * Return Value:
 * <NONE>
 *
 * Example:
 * [logic] call skua_missions_fnc_moduleArsenalSetReference;
 *
 * Public: No
 */

params ["_logic"];
TRACE_1("fnc_moduleArsenalSetReference",_this);

private _objectName = _logic getVariable ["objectReference", ""];
if (_objectName isEqualTo "") exitWith {};

private _object = missionNamespace getVariable [_objectName, objNull];
if (isNull _object) exitWith {};

private _side = _logic getVariable ["Side", 1];
_side = switch (_side) do {
    case (1): {west};
    case (2): {east};
    case (3): {resistance};
    case (4): {civilian};
    default {sideUnknown};
};

if (_side == sideUnknown) then {
    // Set for all sides
    {
        GVAR(baseArsenals) set [_x, _object];
    } forEach (values GVAR(baseArsenals));
} else {
    // Set for specified side
    GVAR(baseArsenals) set [_side, _object];
};

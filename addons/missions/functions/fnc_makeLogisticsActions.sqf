#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Build the Logistics Menu action tree for an object.
 *
 * Arguments:
 * 0: Target object <OBJECT>
 *
 * Return Value:
 * Return description <NONE>
 *
 * Example:
 * call skua_missions_fnc_makeLogisticsActions;
 *
 * Public: No
 */
params ["_target"];
TRACE_1("fnc_makeLogisticsActions",_this);

private _actions = [];
{
    _actions pushBack [_x, [], _target];
} forEach GVAR(logisticsMenuActions);

_actions // return

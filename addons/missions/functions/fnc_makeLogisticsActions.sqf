#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Build the Logistics Menu action tree.
 *
 * Arguments:
 * None.
 *
 * Return Value:
 * Return description <NONE>
 *
 * Example:
 * call skua_missions_fnc_makeLogisticsActions;
 *
 * Public: No
 */
TRACE_1("fnc_makeLogisticsActions",_this);

if (isNil QGVAR(logisticsMenuActions)) then {
    private _objects = call FUNC(logistics_getObjects);
    GVAR(logisticsMenuActions) = _objects apply { _x call FUNC(logistics_makeLogiObjectAction) };
};

GVAR(logisticsMenuActions) // return

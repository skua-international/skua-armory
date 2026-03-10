#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Compiles Logistics Menu Actions.
 *
 * Arguments:
 * None.
 *
 * Return Value:
 * List of actions <ARRAY>
 *
 * Example:
 * call skua_missions_fnc_compileLogisticsMenuActions;
 *
 * Public: No
 */

TRACE_1("fnc_compileLogisticsMenuActions",_this);

GVAR(logisticsObjects) apply { _x call FUNC(logistics_makeLogiObjectAction) };

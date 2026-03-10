#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Check whether the unit can open the Logistics Menu.
 * The Logistics Menu is acessible while inside a Logistics Area and allows the player to pull logistics objects.
 *
 * Arguments:
 * 0: The unit to check <OBJECT>
 *
 * Return Value:
 * Can open <BOOL>
 *
 * Example:
 * call skua_missions_fnc_canOpenLogisticsMenu;
 *
 * Public: No
 */
params ["_unit"];

[_unit, GVAR(logisticsAreas)] call FUNC(inAnySideArea) // return

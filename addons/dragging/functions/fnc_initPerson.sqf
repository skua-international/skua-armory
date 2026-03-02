#include "..\script_component.hpp"
/*
 * Authors: Grim
 * Set CAManBase ace_dragging_ignoreWeight & ignoreWeightCarry to 1 to allow dragging of all infantry regardless of loadout weight.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * bob call skua_dragging_fnc_initPerson;
 *
 * Public: No
 */

params ["_unit"];

_unit setVariable [QACEGVAR(dragging,ignoreWeightDrag), true];
_unit setVariable [QACEGVAR(dragging,ignoreWeightCarry), true];

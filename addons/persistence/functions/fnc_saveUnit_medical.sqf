#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a unit's medical state to a holder hashmap
 *
 * Arguments:
 * 0: Unit to save <OBJECT>
 * 1: Holder hashmap <HASHMAP>
 *
 * Return Value:
 * None, hashmap is modified.
 *
 * Example:
 * [cursorObject, create] call skua_persistence_fnc_saveUnit_medical;
 *
 * Public: No
 */
params ["_unit", "_holder"];

private _medical = _unit call ACEFUNC(medical,serializeState);

_holder set [HASHKEY_UNIT_MEDICAL, _medical];

nil // return

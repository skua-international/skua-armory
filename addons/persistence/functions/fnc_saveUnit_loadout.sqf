#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a unit's loadout to a holder hashmap
 *
 * Arguments:
 * 0: Unit to save <OBJECT>
 * 1: Holder hashmap <HASHMAP>
 *
 * Return Value:
 * None, hashmap is modified.
 *
 * Example:
 * [cursorObject, create] call skua_persistence_fnc_saveUnit_loadout;
 *
 * Public: No
 */
params ["_unit", "_holder"];

private _loadout = _unit call CBA_fnc_getLoadout;

_holder set [HASHKEY_UNIT_LOADOUT, _loadout];

nil // return

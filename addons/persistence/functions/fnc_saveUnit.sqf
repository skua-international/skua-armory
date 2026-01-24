#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a unit's state to a holder hashmap
 *
 * Arguments:
 * 0: Unit to save <OBJECT>
 * 1: Holder hashmap <HASHMAP>
 *
 * Return Value:
 * None, hashmap is modified.
 *
 * Example:
 * [cursorObject, create] call skua_persistence_fnc_saveUnit;
 *
 * Public: No
 */
params ["_unit", "_holder"];

[_unit, _holder] call FUNC(saveUnit_loadout);
[_unit, _holder] call FUNC(saveUnit_medical);

if (isPlayer _unit) then {
    [_unit, _holder] call FUNC(savePlayer);
};

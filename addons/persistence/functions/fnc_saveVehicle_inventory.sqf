#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a vehicle's inventory to a holder hashmap.
 *
 * Arguments:
 * 0: Vehicle to save <OBJECT>
 * 1: Holder hashmap <HASHMAP>
 *
 * Return Value:
 * None, hashmap is modified.
 *
 * Example:
 * [cursorObject, create] call skua_persistence_fnc_saveVehicle_inventory;
 *
 * Public: No
 */
params ["_vehicle", "_holder"];

private _containers = everyContainer _vehicle;
{
    _x params ["_classname", "_object"];
    private _containerMap = createHashMap;
    _containerMap set [HASHKEY_OBJECT_CLASSNAME, _classname];
    [QGVAR(saveContainer), [_object, _containerMap]] call CBA_fnc_serverEvent;
} forEach _containers;

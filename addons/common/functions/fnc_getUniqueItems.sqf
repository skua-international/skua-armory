#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Get a set of unique items and their quantities from an inventory. Weapon attachments are not collapsed. Sub-inventory items are not included.
 *
 * Arguments:
 * 0: Inventory <OBJECT>
 *
 * Return Value:
 * Items and quantities <HASHMAP<STRING, NUMBER>>
 *
 * Example:
 * [myBox] call skua_common_fnc_getUniqueItems;
 *
 * Public: No
 */

params ["_inventory"];
TRACE_1("fnc_getUniqueItems",_this);

private _items = createHashMapFromArray [
    ["items", createHashMap],
    ["magazines", createHashMap],
    ["weapons", createHashMap],
    ["backpacks", createHashMap],
    ["all", createHashMap] // For easy iteration, contains all of the above
];

(getItemCargo _inventory) params ["_itemCargo", "_itemCount"];
{
    _items get "items" set [_x, _itemCount select _forEachIndex];
    _items get "all" set [_x, _itemCount select _forEachIndex];
} forEach _itemCargo;

(getMagazineCargo _inventory) params ["_magCargo", "_magCount"]; // Ammo count is lost
{
    _items get "magazines" set [_x, _magCount select _forEachIndex];
    _items get "all" set [_x, _magCount select _forEachIndex];
} forEach _magCargo;

(getWeaponCargo _inventory) params ["_weaponCargo", "_weaponCount"]; // Attachments are lost
{
    _items get "weapons" set [_x, _weaponCount select _forEachIndex];
    _items get "all" set [_x, _weaponCount select _forEachIndex];
} forEach _weaponCargo;

(getBackpackCargo _inventory) params ["_backpackCargo", "_backpackCount"];
{
    _items get "backpacks" set [_x, _backpackCount select _forEachIndex];
    _items get "all" set [_x, _backpackCount select _forEachIndex];
} forEach _backpackCargo;

_items // return

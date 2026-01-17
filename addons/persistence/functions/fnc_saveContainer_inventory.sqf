#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a container's inventory to a holder hashmap.
 *
 * Arguments:
 * 0: Container to save <OBJECT>
 * 1: Holder hashmap <HASHMAP>
 *
 * Return Value:
 * None, hashmap is modified.
 *
 * Example:
 * [cursorObject, create] call skua_persistence_fnc_saveContainer_inventory;
 *
 * Public: No
 */
params ["_container", "_holder"];

private _containers = everyContainer _container; // containers may have nested containers
{
    _x params ["_classname", "_object"];

    private _containerMap = createHashMap;
    _containerMap set [HASHKEY_OBJECT_CLASSNAME, _classname];

    [QGVAR(saveContainer), [_object, _containerMap]] call CBA_fnc_serverEvent;
} forEach _containers;

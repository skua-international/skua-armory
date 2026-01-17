#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save an object
 *
 * Arguments:
 * 0: Object to save <OBJECT>
 *
 * Return Value:
 * Hashmap with save data
 *
 * Example:
 * [cursorObject] call skua_persistence_fnc_saveObject;
 *
 * Public: No
 */
params ["_object"];

if (!isServer) exitWith {createHashMap}; // Only server can save

private _hasUUID = !(_object isNil QGVAR(uuid));
private _forceSave = _object getVariable [QGVAR(save), false];
if (!_hasUUID && !_forceSave && !GVAR(saveAllObjects)) exitWith {createHashMap};

private _holder = createHashMap;

// Save the classname
_holder set [HASHKEY_OBJECT_CLASSNAME, configName (configOf _object)];

// Save the worldName, see script_macros_persistence.hpp
_holder set [HASHKEY_OBJECT_WORLDNAME, worldName];

private _worldHolder = createHashMap;
_holder set [worldName, _worldHolder];

// Save the UUID
if (_hasUUID) then {
    // If UUID is not present, the database will generate one when saving to the database
    holder set [HASHKEY_OBJECT_UUID, _object getVariable QGVAR(uuid)];
};

// Data independent of the current world (terrain): vehicle damage, fuel, inventory, ammo, etc.
[QGVAR(saveObject), [_object, _holder]] call CBA_fnc_serverEvent;

// Data dependent of the current world (terrain): position, medical state, etc.
[QGVAR(saveObjectWorld), [_object, _worldHolder]] call CBA_fnc_serverEvent;

private _objectKind = switch true do {
    case (_object isKindOf "CAManBase"): {"Unit"};
    // Vehicles
    // Static Weapons
    // Other objects
    default {""}
};

private _eventName = format [QGVAR(save%1), _objectKind];

// e.g., QGVAR(saveUnit), QGVAR(saveUnitWorld)
[_eventName, [_object, _holder]] call CBA_fnc_serverEvent;
[_eventName + "World", [_object, _worldHolder]] call CBA_fnc_serverEvent;

_holder // return

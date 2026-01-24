#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save an object's position, direction, and orientation as vector of string to a holder hashmap
 *
 * Arguments:
 * 0: Object to save <OBJECT>
 * 1: Holder hashmap <HASHMAP>
 *
 * Return Value:
 * None, hashmap is modified.
 *
 * Example:
 * [cursorObject, createHashmap] call skua_persistence_fnc_saveObject_position;
 *
 * Public: No
 */
params ["_object", "_holder"];

// toFixed -1 might have a performance improvement, but this is safer
private _position = (getPosATL _object) apply {_x toFixed 8};

_holder set [HASHKEY_OBJECT_POSITION, _position];

private _direction = (getDir _object) toFixed 3;
_holder set [HASHKEY_OBJECT_DIRECTION, _direction];

private _vectorDir = vectorDir _object;
private _vectorUp = vectorUp _object;
private _orientation = [_vectorDir, _vectorUp] apply {_x apply {(_x) toFixed 8}};
_holder set [HASHKEY_OBJECT_ORIENTATION, _orientation];

nil // return

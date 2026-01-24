#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a serialized object's state to persistent storage (database, profileNamespace)
 *
 * Arguments:
 * 0: Serialized object <HASHMAP>
 *
 * Return Value:
 * None.
 *
 * Example:
 * createHashMap call skua_persistence_fnc_persistObject;
 *
 * Public: No
 */
params ["_serializedObject"];

"skua" callExtension ["persist:save", [_serializedObject, GVAR(key), GVAR(sessionId)]];

nil // return

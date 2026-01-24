#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a player's state to a holder hashmap.
 * Player state includes additional data from unit state: rank, admin status, certifications, etc.
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

_holder set [HASHKEY_PLAYER_STEAM_ID, getPlayerUID _unit];

_holder set [HASHKEY_PLAYER_RANK, _unit getVariable QGVAR(rank)];

_holder set [HASHKEY_PLAYER_ADMINSTATUS, _unit getVariable QGVAR(admin)];

_holder set [HASHKEY_PLAYER_CERTIFICATIONS, _unit getVariable QGVAR(certifications)];

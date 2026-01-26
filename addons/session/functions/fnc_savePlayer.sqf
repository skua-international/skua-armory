#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Save a player to the session namespace.
 *
 * Arguments:
 * 0: The player object <OBJECT>
 *
 * Return Value:
 * Return description <NONE>
 *
 * Example:
 * [grim] call skua_session_fnc_savePlayer
 *
 * Public: No
 */

#define EXPIRATION_TIME 900 // session data is valid for 15 minutes

params ["_player", ["_uid", ""]];
TRACE_1("fnc_savePlayer",_this);

toFixed 8;

if (_uid == "") then {
    _uid = getPlayerUID _player;
};

private _deadline = diag_tickTime + EXPIRATION_TIME;

private _playerHolder = GVAR(namespace) getOrDefault [_uid, createHashMap, true];

_playerHolder set ["deadline", _deadline];
_playerHolder set ["loadout", _player call CBA_fnc_getLoadout];
_playerHolder set ["position", str (getPosATL _player)];
_playerHolder set ["medical", _player call ACEFUNC(medical,serializeState)];
_playerHolder set ["stance", stance _player];
_playerHolder set ["dir", getDir _player];

// Hook for database persistence
[QGVAR(savedPlayer), [_player, _playerHolder]] call CBA_fnc_serverEvent;

INFO_2("Saved session data for player %1 with deadline %2",_uid,_deadline);

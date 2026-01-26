#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Load a player from the session namespace.
 *
 * Arguments:
 * 0: The player object <OBJECT>
 *
 * Return Value:
 * Return description <NONE>
 *
 * Example:
 * [grim] call skua_session_fnc_loadPlayer
 *
 * Public: No
 */

params ["_player"];
TRACE_1("fnc_loadPlayer",_this);

toFixed 8;

private _uid = getPlayerUID _player;

private _playerHolder = GVAR(namespace) get _uid;
if (isNil "_playerHolder") exitWith {};

// Always load the loadout for convenience
[_player, _playerHolder get "loadout"] call CBA_fnc_setLoadout;

private _deadline = _playerHolder get "deadline";
if (diag_tickTime > _deadline) exitWith {};

// Medical and position only if still valid
private _pos = parseSimpleArray (_playerHolder get "position");
_player setPosATL _pos;
if (!isTouchingGround _player) then { // prevent spawning in mid-air
    _pos set [2, 0];
    _player setPosATL _pos;
};

private _medical = _playerHolder get "medical";
[_player, _medical] call ACEFUNC(medical,deserializeState);

private _stance = _playerHolder get "stance";
switch (_stance) do {
    case "CROUCH": {
        _player call ACEFUNC(common,goKneeling);
    };
    case "PRONE": {
        _player call ACEFUNC(common,setProne);
    };
    default {};
};

// Hook for database persistence
[QGVAR(loadedPlayer), [_player, _playerHolder]] call CBA_fnc_serverEvent;

INFO_2("Loaded session data for player %1 with deadline %2",_uid,_deadline);


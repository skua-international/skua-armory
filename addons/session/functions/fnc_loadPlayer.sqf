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

private _uid = getPlayerUID _player;

private _playerHolder = GVAR(namespace) get _uid;
if (isNil "_playerHolder") exitWith {};

// Always load the loadout for convenience
[_player, _playerHolder get "loadout"] call CBA_fnc_setLoadout;

private _deadline = _playerHolder get "deadline";
if (diag_tickTime > _deadline) exitWith {};

// Medical and position only if still valid
private _pos = _playerHolder get "position";
_player setPosASL [parseNumber (_pos select 0), parseNumber (_pos select 1), parseNumber (_pos select 2)];

private _dir = _playerHolder get "dir";
_player setDir (parseNumber _dir);

private _medical = _playerHolder get "medical";
[{
    params ["_player"];
    _player getVariable [QACEGVAR(medical,initialized), false];
}, {
    params ["_player", "_medical"];
    [_player, _medical] call ACEFUNC(medical,deserializeState);
}, [_player, _medical]] call CBA_fnc_waitUntilAndExecute;

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


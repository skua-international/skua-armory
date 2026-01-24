#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Call the extension to load player data from the database.
 * If player data does not exist, the extension will create a new entry.
 * Asynchronous, this is just the extension call. The response will be handled in FUNC(handleLoadPlayerData).
 *
 * Arguments:
 * 0: Player Object <OBJECT>
 *
 * Return Value:
 * None.
 *
 * Example:
 * call skua_persistence_fnc_databaseBootstrap;
 *
 * Public: No
 */

params ["_player"];

private _uid = getPlayerUID _player;

private _state = "skua" callExtension ["player:loadData", [_uid, GVAR(key), GVAR(sessionId)]];
if (parseNumber (_state select 0) != 0) exitWith {
    ERROR_1("Load player data call failed with state: %1",_state select 0);
};

INFO_2("Loading player data for %1, UID: %2",name _player,_uid);

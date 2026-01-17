#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Creates Zeus module for admins on connection.
 *
 * Arguments:
 * 0: UID (Steam ID) of client <STRING>
 * 1: Has Interface (not headless) <BOOL>
 * 2: Player Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject] call skua_admin_fnc_createAdminZeus;
 *
 * Public: No
 */

#define DELAY_SECS_CREATE_ZEUS 1

params ["_uid", "_hasInterface", "_playerObject"];

if (!isServer) exitWith {}; // TODO: should log something?

INFO_3("Client connected: %1 with UID %2, hasInterface: %3",name _playerObject,_uid,_hasInterface);

if (!_hasInterface) exitWith {}; // No interface, no Zeus

private _fnc_createZeus = {
    INFO_1("Creating Zeus module for admin player: %1",name _this);
    [QACEGVAR(zeus,createZeus), _this] call CBA_fnc_serverEvent;
};

if (_uid in GVAR(admins)) then {
    INFO_2("Scheduling Zeus module creation for admin player %1 with UID %2",name _playerObject,_uid);
    [_fnc_createZeus, _playerObject, DELAY_SECS_CREATE_ZEUS] call CBA_fnc_waitAndExecute;
};

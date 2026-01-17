#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Handle receiving client's addon list on server.
 *
 * Arguments:
 * 0: UID (Steam ID) of client <STRING>
 * 1: Player object of the client, used for the target event <OBJECT>
 * 2: Full Addon List from client <ARRAY of STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * call skua_admin_fnc_onClientAddons;
 *
 * Public: No
 */

params ["_uid", "_playerObject", "_fullAddonList"];

if (!isServer) exitWith {}; // Only the server cares about this

// Check if we have a record of this client's addons already

if (_uid in GVAR(clientAddonMap)) exitWith {
    ERROR_1("Received duplicate addon list from client with UID %1, ignoring",_uid);
    // TODO: could be foul play, log it somewhere
};

private _extraAddons = _fullAddonList - GVAR(serverAddons);
private _missingAddons = GVAR(serverAddons) - _fullAddonList;

INFO_4("Client %1 with UID %2 has %3 extra addons and %4 missing addons",name _playerObject,_uid,count _extraAddons,count _missingAddons);

GVAR(clientAddonMap) set [_uid, [_extraAddons, _missingAddons]];

if (count _missingAddons > 0) then {
    private _missingMods = _missingAddons call FUNC(getModNamesFromAddons);

    INFO_3("Client %1 with UID %2 is missing mods: %3",name _playerObject,_uid,_missingMods joinString ", ");
};

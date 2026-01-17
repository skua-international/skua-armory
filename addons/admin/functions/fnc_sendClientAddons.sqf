#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Send client's addon list to server on connect.
 *
 * Return Value:
 * None
 *
 * Example:
 * call skua_admin_fnc_sendClientAddons;
 *
 * Public: No
 */

if (!hasInterface) exitWith {}; // We don't care about headless clients

private _addons = cba_common_addons; // CBA is reliable

// Send to the server and let it sort it out
[QGVAR(addons), [getPlayerUID player, player, _addons]] call CBA_fnc_serverEvent;

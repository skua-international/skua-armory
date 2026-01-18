#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Ask the server for a client's addon list.
 * Must be run scheduled.
 *
 * Arguments:
 * 0: UID (Steam ID) of client <STRING>
 *
 * Return Value:
 * List of extra addons, list of missing addons on client <ARRAY of ARRAY of STRING>
 *
 * Example:
 * spawn skua_admin_fnc_getClientAddons;
 *
 * Public: No
 */

#define TIMEOUT_SECS_GET_ADDONS 5

params ["_uid"];

if (!canSuspend) exitWith {};

// Create a temporary namespace to receive the response
private _namespace = true call CBA_fnc_createNamespace;

[QGVAR(requestClientAddons), [getPlayerUID player, _uid, _namespace, clientOwner]] call CBA_fnc_serverEvent;

private _varName = format [QGVAR(clientAddons_%1), _uid];

// Block until we get a response
private _startTime = diag_tickTime;
private _deadline = _startTime + TIMEOUT_SECS_GET_ADDONS;

waitUntil {sleep 0.1; !(_namespace isNil _varName) || (diag_tickTime > _deadLine)};

if (_namespace isNil _varName) exitWith {
    ERROR_1("Timed out waiting for addon list of client with UID %1",_uid);
    // Timed out
    [[], []];
};

(_namespace getVariable _varName) params ["_extraAddons", "_missingAddons"];

private _return = [+_extraAddons, +_missingAddons]; // make sure we return copies

// Clean up
_namespace call CBA_fnc_deleteNamespace;

_return

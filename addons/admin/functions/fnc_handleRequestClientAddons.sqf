#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Answer an admin's request for a client's addon list.
 *
 * Arguments:
 * 0: UID (Steam ID) of client <STRING>
 * 1: Full Addon List from client <ARRAY of STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * call skua_admin_fnc_handleRequestClientAddons;
 *
 * Public: No
 */
params ["_requestingAdminUID", "_targetClientUID", "_namespace", "_requestOwnerMachineID"];

if (!isServer) exitWith {}; // Only the server cares about this

private _varName = format [QGVAR(clientAddons_%1), _targetClientUID];

if !(_requestingAdminUID in GVAR(admins)) exitWith {
    ERROR_1("Received addon list request from non-admin UID %1, ignoring",_requestingAdminUID);
    _namespace setVariable [_varName, [[], []]]; // Send empty lists
};

if !(_targetClientUID in GVAR(clientAddonMap)) exitWith {
    ERROR_2("No addon list recorded for client UID %1, cannot fulfill request from admin UID %2",_targetClientUID,_requestingAdminUID);
    _namespace setVariable [_varName, [[], []]]; // Send empty lists
};

private _addonLists = GVAR(clientAddonMap) get _targetClientUID;
INFO_3("Sending addon list of client UID %1 to admin UID %2: %3",_targetClientUID,_requestingAdminUID,_addonLists);
_namespace setVariable [_varName, _addonLists, _requestOwnerMachineID];

#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Handle extension callback for loading player data.
 *
 * Arguments:
 * 0: Extension name (in theory, extension may report something else) <STRING>
 * 1: Function name (arbitrary, defined by extension) <STRING>
 * 2: Data: returned data from the extension and error codes. <STRING>
 *
 * Return Value:
 * None.
 *
 * Example:
 * call skua_persistence_fnc_loadPlayerData;
 *
 * Public: No
 */
params ["", "", "_data"];
(parseSimpleArray _data) params ["_uid", "_loadout", "_position", "_medicalData"];
INFO_1("Player data loaded for UID: %1",_uid);

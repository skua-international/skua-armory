#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Request loading of player data from the database.
 *
 * Arguments:
 * None.
 *
 * Return Value:
 * None.
 *
 * Example:
 * call skua_persistence_fnc_request_loadPlayerData;
 *
 * Public: No
 */

[QGVAR(loadPlayerData), [player]] call CBA_fnc_serverEvent;

#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Set the default 3DEN Scenario attributes: respawn delay, disable AI, etc.
 *
 * Arguments:
 * None.
 *
 * Return Value:
 * None.
 *
 * Example:
 * call skua_editor_fnc_setDefault3DENAttributes;
 *
 * Public: No
 */

set3DENMissionAttributes [
    ["Multiplayer", "GameType", "Zeus"],
    ["Multiplayer", "MinPlayers", 0],
    ["Multiplayer", "MaxPlayers", (count playableUnits) + 4], // Headless Client support, allow four more players than the number of playable units
    ["Multiplayer", "DisabledAI", true],
    ["Multiplayer", "JoinUnassigned", true],
    ["Multiplayer", "Respawn", 3],
    ["Multiplayer", "RespawnTemplates", ["MenuPosition"]],
    ["Multiplayer", "RespawnDelay", 3],
    ["Multiplayer", "RespawnVehicleDelay", 3],
    ["Multiplayer", "RespawnDialog", false]
];

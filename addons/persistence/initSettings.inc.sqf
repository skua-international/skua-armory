// All settings in this file should be suffixed with _setting.
// The proper variable used in scripts is without the suffix, e.g. persistenceKey_setting -> persistenceKey
// This is to avoid issues with changing the setting at runtime and scripts using the updated value.
// For settings changes to take effect, a mission restart is required.

[
    QGVAR(enabled_setting), "CHECKBOX",
    [
        "Enable Persistence", 
        "If enabled, the persistence system will be active, saving and loading player data across missions." +
        "\nDisabling this will prevent any data from being saved or loaded, effectively turning off persistence functionality."
    ],
    ["Skua Mods", "Persistence Options"],
    false,
    1
] call CBA_fnc_addSetting;

[
    QGVAR(key_setting), "EDITBOX",
    [
        "Campaign Persistence Key", 
        "The key used to identify the current campaign." +
        "\nA campaign is a collection of saved data that persists across missions." +
        "\nDo not modify this value unless you intend to have saved data separated from other missions." +
        "\nOne-shots and missions that do not have specific persistence requirements should use the default value."
    ],
    ["Skua Mods", "Persistence Options"],
    "default",
    1
] call CBA_fnc_addSetting;

[
    QGVAR(environment_setting), "LIST",
    [
        "Persistence Environment", 
        "Determines which environment the persistence data is saved to." +
        "\nMostly irrelevant unless you are testing or developing." +
        "\nProduction is the live environment used for actual gameplay." +
        "\nDevelopment is a separate environment used for testing and development purposes."
    ],
    ["Skua Mods", "Persistence Options"],
    [["dev","prod"], ["Development", "Production"], 1],
    1
] call CBA_fnc_addSetting;

[
    QGVAR(location_setting), "LIST",
    [
        "Persistence Location", 
        "Determines where the persistence data is stored." +
        "\nLocal will store data on the server profile itself." +
        "\nRemote will store data in a remote database server." +
        "\nRemote storage requires additional setup and configuration." +
        "\nLocal storage should only be used for testing purposes, as it does not provide true persistence across server wipes or migrations."
    ],
    ["Skua Mods", "Persistence Options"],
    [[0,1], ["Local", "Remote"], 1],
    1
] call CBA_fnc_addSetting;

[
    QGVAR(saveLoadouts_setting), "LIST",
    [
        "Loadout Persistence", 
        "Determines how loadouts are saved and loaded." +
        "\nCampaign-specific will save loadouts as part of the campaign." +
        "\nEnabled will save loadouts locally on the server."
    ],
    ["Skua Mods", "Persistence Options"],
    [[2,1,0], ["Disabled", "Campaign", "Global"], 2],
    1
] call CBA_fnc_addSetting;

[
    QGVAR(savePosition_setting), "CHECKBOX",
    [
        "Position Persistence", 
        "If enabled, player positions will be saved and restored on reconnect." +
        "\nPositions are saved as part of the campaign and are specific to the current map." +
        "\nDisabling this will cause players to respawn at default spawn points on reconnect, and their last position will not be saved."
    ],
    ["Skua Mods", "Persistence Options"],
    true,
    1
] call CBA_fnc_addSetting;

[
    QGVAR(saveMedical_setting), "CHECKBOX",
    [
        "Medical Persistence", 
        "If enabled, player medical states (injuries, blood levels, etc.) will be saved and restored on reconnect." +
        "\nMedical states are saved as part of the campaign and are specific to the current map." +
        "\nDisabling this will cause players to respawn with default medical states on reconnect." +
        "\nIt is recommended to enable this when saving positions to maintain continuity and avoid exploits, such as combat logging to heal injuries."
    ],
    ["Skua Mods", "Persistence Options"],
    true,
    1
] call CBA_fnc_addSetting;

[
    QGVAR(ephemeralDataTimeout_setting), "TIME",
    [
        "Ephemeral Data Timeout", 
        "The duration for which ephemeral player data is valid after a player disconnects." +
        "\nEphemeral data includes position and medical state saved for reconnecting players within the same mission session." +
        "\nAfter this timeout period, the ephemeral data will be considered expired and will not be loaded." +
        "\nSet to 0 to disable expiry of ephemeral data." +
        "\nEphemeral data is cleared when the mission ends regardless of this setting. Saving ephemeral data cannot be disabled."
    ],
    ["Skua Mods", "Persistence Options"],
    [0, 60 * 60 * 24, 15 * 60], // Min: 0 seconds, Max: 86400 seconds (24 hours), Default: 900 seconds (15 minutes)
    1
] call CBA_fnc_addSetting;

#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Get a list of mod names from a list of addon names. Addons must exist in the executing machine.
 *
 * Arguments:
 * 0: List of addons <ARRAY of STRING>
 *
 * Return Value:
 * List of mod names.
 *
 * Example:
 * ["ace_medical", "ace_medical_engine"] call skua_admin_fnc_getModNamesFromAddons;
 *
 * Public: No
 */

private _allLoadedModsInfo = getLoadedModsInfo;

private _cfgPatches = configFile >> "CfgPatches";

// hashmap for a set
private _sourceModDirs = createHashMap;
{
    // Get the mod directories for all of the addons
    // Force lowercase so we can lookup
    _sourceModDirs set [(toLowerANSI configSourceMod (_cfgPatches >> _x)), nil];
} forEach _this;

private _addonsLoadedModsInfo = _allLoadedModsInfo select {(toLowerANSI (_x select 1)) in _sourceModDirs};

_addonsLoadedModsInfo apply {_x select 0} // return

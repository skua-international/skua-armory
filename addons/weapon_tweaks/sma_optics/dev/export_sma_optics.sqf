// call compileScript ["z\skua\addons\weapon_tweaks\sma_optics\dev\export_sma_optics.sqf"]

#include "..\script_component.hpp"

private _requiredAddons = (getArray (configFile >> "CfgPatches" >> QUOTE(SUBADDON) >> "requiredAddons")) - ["sma_vortex_optics"];

private _condition = toString {
    (_requiredAddons findAny configSourceAddonList _x) != -1
};

(_condition configClasses (configFile >> "CfgWeapons")) apply {configName _x}

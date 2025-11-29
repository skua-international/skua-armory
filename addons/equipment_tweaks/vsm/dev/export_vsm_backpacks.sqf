// call compileScript ["z\skua\addons\equipment_tweaks\vsm\dev\export_vsm_backpacks.sqf"]

#include "..\script_component.hpp"

private _configVehicles = configFile >> "CfgVehicles";

private _condition = toString {
    ["@Ghost's MLO Additions","@VSM All-In-One Collection"] findAny (configSourceModList _x) != -1 &&
    {getNumber (_x >> "isBackpack") == 1}
};

private _allVsmBackpacks = (_condition configClasses _configVehicles);

private _backpackData = _allVsmBackpacks apply {[configName _x, getText (_x >> "displayName")]};

_backpackData sort true;

copyToClipboard ((str _backpackData) regexReplace ["\],","],\n"])

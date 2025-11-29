// call compileScript ["z\skua\addons\equipment_tweaks\vsm\dev\export_vsm_vests.sqf"]

#include "..\script_component.hpp"

private _configWeapons = configFile >> "CfgWeapons";

private _condition = toString {
    ["@Ghost's MLO Additions","@VSM All-In-One Collection"] findAny (configSourceModList _x) != -1 &&
    {getNumber (_x >> "ItemInfo" >> "Type") == TYPE_VEST}
};

private _allVsmVests = (_condition configClasses _configWeapons);

private _vestData = _allVsmVests apply {[configName _x, getText (_x >> "displayName"), configName ((inheritsFrom _x))]};

_vestData sort true;

copyToClipboard ((str _vestData) regexReplace ["\],","],\n"])

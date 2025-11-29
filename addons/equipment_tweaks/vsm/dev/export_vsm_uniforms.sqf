// call compileScript ["z\skua\addons\equipment_tweaks\vsm\dev\export_vsm_uniforms.sqf"]

#include "..\script_component.hpp"

private _configWeapons = configFile >> "CfgWeapons";

private _condition = toString {
    ["@Ghost's MLO Additions","@VSM All-In-One Collection"] findAny (configSourceModList _x) != -1 &&
    {getNumber (_x >> "ItemInfo" >> "Type") == TYPE_UNIFORM}
};

private _allVsmUniforms = (_condition configClasses _configWeapons);

private _uniformData = _allVsmUniforms apply {[configName _x, getText (_x >> "displayName")]};

_uniformData sort true;

copyToClipboard ((str _uniformData) regexReplace ["\],","],\n"])

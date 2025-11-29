/*
    Author:
        Karel Moricky, optimised by Killzone_Kid

    Description:
        Sets unit inisgnia (e.g., shoulder insignia on soldiers)

    Parameter(s):
        0: OBJECT - unit
        1: STRING - CfgUnitInsignia class. Use an empty string to remove current insignia.

    Returns:
        BOOL - true if insignia was set
*/

/// --- validate input

#define DEFAULT_MATERIAL "\a3\data_f\default.rvmat"
#define DEFAULT_TEXTURE "#(rgb,8,8,3)color(0,0,0,0)"

params [["_unit", objNull, [objNull]], ["_class", "", [""]]];

// --- load texture from config.cpp or description.ext
private _cfgInsignia = [["CfgUnitInsignia", _class], configNull] call BIS_fnc_loadClass;

// --- check if insignia exists
if (configName _cfgInsignia != _class) exitWith
{
    [
        "'%1' is not found in CfgUnitInsignia. Available classes: %2",
        _class,
        ("true" configClasses (configFile >> "CfgUnitInsignia") apply {configName _x})
        +
        ("true" configClasses (missionConfigFile >> "CfgUnitInsignia") apply {configName _x})
        +
        ("true" configClasses (campaignConfigFile >> "CfgUnitInsignia") apply {configName _x})
    ]
    call BIS_fnc_error;
    false
};

private _set = false;
private _unitSelections = selectionNames _unit;
if (_unitSelections findIf {_x == "insignia"} == -1) exitWith {
    false
};

isNil { // --- make it safe in scheduled
    if (_unit call BIS_fnc_getUnitInsignia != _class) then {
        _unit setVariable ["BIS_fnc_setUnitInsignia_class", [_class, nil] select (_class isEqualTo ""), true];
        _unit setObjectMaterialGlobal ["insignia", getText (_cfgInsignia >> "material") call {[_this, DEFAULT_MATERIAL] select (_this isEqualTo "")}];
        _unit setObjectTextureGlobal ["insignia", getText (_cfgInsignia >> "texture") call {[_this, DEFAULT_TEXTURE] select (_this isEqualTo "")}];
        _set = true
    };
};

_set

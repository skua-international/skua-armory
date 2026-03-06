#include "script_component.hpp"

call FUNC(notifyClientConnected);

GVAR(camoCoefMap) = createHashMap;

["CAManBase", "SlotItemChanged", {
    params ["_unit", "_name", "_slot", "_assigned"];
    if (!local _unit || {_slot != TYPE_UNIFORM}) exitWith {};
    if (!_assigned) exitWith {
        _unit setUnitTrait ["camouflageCoef", 1];
    };

    private _baseCamo = GVAR(camoCoefMap) getOrDefaultCall [typeOf _unit, {
        // at least this is easy
        // a uniform is actually a reference to the textures and model of a CfgVehicles class
        // but actual camo is based on the unit, not the uniform it's wearing
        // basically just do configOf and divide and we'll get a coef setting it to what it should be
         getNumber (configOf _unit >> "camouflage")
    }, true];

    private _uniformCamo = GVAR(camoCoefMap) getOrDefaultCall [_name, {
        private _uniformClass = getText (configFile >> "CfgWeapons" >> _name >> "ItemInfo" >> "uniformClass");
        getNumber (configFile >> "CfgVehicles" >> _uniformClass >> "camouflage")
    }, true];

    if (_baseCamo == 0 || _uniformCamo == 0) exitWith {
        _unit setUnitTrait ["camouflageCoef", 1];
    };

    // Calculate the camo coef
    private _camoCoef = _uniformCamo / _baseCamo;

    _unit setUnitTrait ["camouflageCoef", _camoCoef];
}] call CBA_fnc_addClassEventHandler;

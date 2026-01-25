#include "script_component.hpp"

// Camo coef for vanilla standard military uniforms
#define BASELINE_CAMO_COEF 1.4

call FUNC(notifyClientConnected);

GVAR(camoCoefMap) = createHashMap;

["CAManBase", "SlotItemChanged", {
    params ["_unit", "_name", "_slot", "_assigned"];
    if (!local _unit || {_slot != TYPE_UNIFORM}) exitWith {};
    if (!_assigned) exitWith {
        _unit setUnitTrait ["camouflageCoef", 1];
    };

    private _camoCoef = GVAR(camoCoefMap) getOrDefaultCall [uniform _unit, {
        private _uniformCoef = getNumber (configFile >> "CfgVehicles" >> getText (configFile >> "CfgWeapons" >> (uniform _unit) >> "ItemInfo" >> "uniformClass") >> "camouflage");

        private _normalizedCoef = _uniformCoef / BASELINE_CAMO_COEF;

        sqrt(_normalizedCoef) // return
    }, true];

    _unit setUnitTrait ["camouflageCoef", _camoCoef];
}] call CBA_fnc_addClassEventHandler;

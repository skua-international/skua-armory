#include "..\script_component.hpp"
#include "\z\ace\addons\arsenal\defines.hpp"

params ["_unit"];

private _missingGear = [_unit, true] call FUNC(getMissingGear);
private _inArsenal = !isNull findDisplay IDD_ace_arsenal;

{
    _x params ["_type", "_classArray", "_count"];
    if (_inArsenal) then {
        _classArray = _classArray select {_x in ACEGVAR(arsenal,virtualItemsFlat)};
    };
    if (_type != "#magazine" && {_classArray isEqualTo []}) then {continue};
    private _class = _classArray param [0, ""];
    switch (_type) do {
        case "#uniform": {
            _unit forceAddUniform _class;
        };
        case "#vest": {
            _unit addVest _class;
        };
        case "#weapon": {
            _unit addWeapon _class;
            private _availableMagazines = ([_class] call CBA_fnc_compatibleMagazines) select {_x in ACEGVAR(arsenal,virtualItemsFlat)};
            if (_availableMagazines isEqualTo []) then {continue};
            private _magazineToAdd = _availableMagazines select 0;
            _unit addWeaponItem [_class, _magazineToAdd, true];
            private _magCount = _unit ammo _class;
            private _ammoCount = [GVAR(requirePrimaryAmmo), GVAR(requireHandgunAmmo)] select (_class == handgunWeapon _unit);
            _magCount = ceil (_ammoCount / _magCount);
            for "_i" from 1 to _magCount do {
                _unit addMagazine _magazineToAdd;
            };
        };
        case "#item": {
            for "_i" from 1 to _count do {
                _unit addItem _class;
            };
        };
        case "#binoammo": {
            _unit addBinocularItem _class;
        };
        case "#radio": { // TFAR-only
            _unit addItem "TFAR_anprc152";
            _unit assignItem "TFAR_anprc152";
        };
        case "#magazine": {
            private _weapon = _x param [3, ""];
            if (_weapon == "") then {continue};
            if (_class isEqualTo "") then {
                private _availableMagazines = [_weapon] call CBA_fnc_compatibleMagazines;
                if (_availableMagazines isEqualTo []) then {continue};
                (_unit weaponState _weapon) params ["", "", "", "_loadedMagazine", "_loadedMagazineAmmo"];
                if (_loadedMagazineAmmo != 0) then {
                    _unit addMagazine [_loadedMagazine, _loadedMagazineAmmo];
                };
                _class = _availableMagazines select 0;
            };
            _unit addWeaponItem [_weapon, _class, true];
            private _magCount = _unit ammo _weapon;
            _magCount = ceil (_count / _magCount);
            for "_i" from 1 to _magCount do {
                _unit addMagazine _class;
            };
        };
        case "#belt": {
            _unit linkItem _class;
        };
    };
} forEach _missingGear;

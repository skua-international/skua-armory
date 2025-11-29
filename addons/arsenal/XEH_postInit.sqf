#include "script_component.hpp"

["CBA_loadoutGet", {
    params ["_unit", "_loadoutArray", "_extendedInfo"];

    if ("grad_slingHelmet_main" call ACEFUNC(common,isModLoaded)) then {
        private _helmetClass = _unit call GRAD_slingHelmet_fnc_getSlungHelmet;
        if (_helmetClass != "") then {
            _extendedInfo set ["grad_slingHelmet_class", _helmetClass];
        };
    };
}] call CBA_fnc_addEventHandler;

[QACEGVAR(arsenal,loadoutVerified), {
    params ["", "_extendedInfo"];
    private _helmetClass = _extendedInfo getOrDefault ["grad_slingHelmet_class", ""];
    if (_helmetClass != "" && {!(_helmetClass in ACEGVAR(arsenal,virtualItemsFlat))}) then {
        _extendedInfo deleteAt "grad_slingHelmet_class";
    };

    private _kjwVarToCheck = ["KJW_TwoPrimaryWeapons_secondPrimaryInfo", "KJW_TwoPrimaryWeapons_primaryPrimaryInfo"] select (_extendedInfo getOrDefault ["KJW_TwoPrimaryWeapons_secondPrimaryEquipped", false]);
    private _weaponData = _extendedInfo getOrDefault [_kjwVarToCheck, []];
    if (_weaponData isNotEqualTo []) then {
        if !((_weaponData select 0) call ACEFUNC(arsenal,baseWeapon) in ACEGVAR(arsenal,virtualItemsFlat)) then {
            _extendedInfo deleteAt _kjwVarToCheck;
        } else {
            {
                private _class = _x param [0, ""];
                private _defaultValue = ["", []] select (_x isEqualType []);
                if (_class != "" && {!(_class in ACEGVAR(arsenal,virtualItemsFlat))}) then {
                    _weaponData set [_forEachIndex + 1, _defaultValue];
                };
            } forEach (_weaponData select [1]);
        };
    };
}] call CBA_fnc_addEventHandler;

["CBA_loadoutSet", {
    params ["_unit", "_loadoutArray", "_extendedInfo"];

    private _helmetClass = _extendedInfo getOrDefault ["grad_slingHelmet_class", ""];
    if ("grad_slingHelmet_main" call ACEFUNC(common,isModLoaded)) then {
        if (_helmetClass call GRAD_slingHelmet_fnc_isWhitelisted) then {
            [_unit, _helmetClass] call GRAD_slingHelmet_fnc_addSlungHelmet;
        };
    };
}] call CBA_fnc_addEventHandler;

#include "..\script_component.hpp"

#define DEFAULT_UNIFORM QUOTE(VSM_OGA_grey_casual_Camo)
#define DEFAULT_VEST QUOTE(VSM_OGA_OD_Vest_1)
#define DEFAULT_RIFLE QUOTE(CUP_arifle_M4A1_standard_black)
#define DEFAULT_PISTOL QUOTE(hgun_P07_F)

params ["_unit", ["_returnClasses", false]];

if (!GVAR(enabled)) exitWith {[]};

if (!isPlayer _unit) exitWith {[]};

private _roles = [_unit] call FUNC(findRoles);

private _unitItems = uniqueUnitItems [_unit, 0, 2, 2, 2, true];
if ("acre_api" call ACEFUNC(common,isModLoaded)) then {
    {
        private _baseRadio = _x call acre_api_fnc_getBaseRadio;
        private _count = _unitItems get _x;
        _unitItems set [_baseRadio, (_unitItems getOrDefault [_baseRadio, 0]) + _count];
        if (_x != _baseRadio) then {
            _unitItems deleteAt _x;
        };
    } forEach ((keys _unitItems) select {_x call acre_api_fnc_isRadio});
};

private _missing = [];
private _missingClasses = [];

if (uniform _unit isEqualTo "") then {
    _missing pushBack "A Uniform";
    _missingClasses pushBack ["#uniform", [DEFAULT_UNIFORM], 1];
};

if (GVAR(requireVest) && {vest _unit isEqualTo ""}) then {
    _missing pushBack "A Vest";
    _missingClasses pushBack ["#vest", [DEFAULT_VEST], 1];
};

// Check for a weapon
if (GVAR(requirePrimary)) then {
    private _weapon = primaryWeapon _unit;
    private _missingRifle = false;
    if (_weapon isEqualTo "") then {
        _missing pushBack "A Rifle";
        _missingClasses pushBack ["#weapon", [DEFAULT_RIFLE], 1];
        _missingRifle = true;
    };
    private _rounds = 0;
    {
        if (_weapon canAdd (_x#0)) then {
            _rounds = _rounds + _x#1;
        };
    } forEach magazinesAmmoFull _unit;
    if (_rounds < GVAR(requirePrimaryAmmo)) then {
        _missing pushBack format ["%1 Primary Rounds", GVAR(requirePrimaryAmmo) - _rounds];
        if (!_missingRifle) then {
            _missingClasses pushBack ["#magazine", primaryWeaponMagazine _unit, GVAR(requirePrimaryAmmo) - _rounds, _weapon];
        };
    };
};

if (GVAR(requireHandgun)) then {
    private _weapon = handgunWeapon _unit;
    private _missingPistol = false;
    if (_weapon isEqualTo "") then {
        _missing pushBack "A Handgun";
        _missingClasses pushBack ["#weapon", [DEFAULT_PISTOL], 1];
        _missingPistol = true;
    };
    private _rounds = 0;
    {
        if (_weapon canAdd (_x#0)) then {
            _rounds = _rounds + _x#1;
        };
    } forEach magazinesAmmoFull _unit;
    if (_rounds < GVAR(requireHandgunAmmo)) then {
        _missing pushBack format ["%1 Handgun Rounds", GVAR(requireHandgunAmmo) - _rounds];
        if (!_missingPistol) then {
            _missingClasses pushBack ["#magazine", handgunMagazine _unit, GVAR(requireHandgunAmmo) - _rounds, _weapon];
        };
    };
};

if (binocular _unit != "" && {binocularMagazine _unit isEqualTo []} && {([binocular _unit] call CBA_fnc_compatibleMagazines) isNotEqualTo []}) then {
    _missing pushBack "Designator Batteries";
    _missingClasses pushBack ["#binoammo", [binocular _unit] call CBA_fnc_compatibleMagazines, 1];
};

if (GVAR(requireEarplugs) && {ACEGVAR(hearing,damageCoefficent) > 0.6 && !("ACE_EarPlugs" in _unitItems)}) then {
    _missing pushBack "Earplugs";
    _missingClasses pushBack ["#item", ["ACE_EarPlugs"], 1];
};

if (GVAR(requireRadio)) then {
    [["ACRE_BF888S"], _unitItems, 1, ["Baofeng 888S", "Baofeng 888S"], _missing, _missingClasses] call FUNC(countItem);
};

[["ACE_fieldDressing","ACE_packingBandage"], _unitItems,
                                      15, ["Bandage (Basic/Packing)", "Bandages (Basic/Packing)"], _missing, _missingClasses] call FUNC(countItem);
[["ACE_splint"], _unitItems,           2, ["Splint", "Splints"], _missing, _missingClasses] call FUNC(countItem);
[["ACE_morphine"], _unitItems,         2, ["Morphine Autoinjector", "Morphine Autoinjectors"], _missing, _missingClasses] call FUNC(countItem);
[["ACE_epinephrine"], _unitItems,      1, ["Epinephrine Autoinjector", "Epinephrine Autoinjectors"], _missing, _missingClasses] call FUNC(countItem);
[["ACE_tourniquet"], _unitItems,       4, ["Tourniquet", "Tourniquets"], _missing, _missingClasses] call FUNC(countItem);
[["SmokeShell"], _unitItems,           2, ["Smoke Grenade (White)", "Smoke Grenades (White)"], _missing, _missingClasses] call FUNC(countItem);
[["ACE_CableTie"], _unitItems,         2, ["Cable Tie", "Cable Ties"], _missing, _missingClasses] call FUNC(countItem);
[["ACE_bloodIV_250", "ACE_salineIV_250", "ACE_plasmaIV_250"], _unitItems,
                                       2, ["250ml IV", "250ml IVs"], _missing, _missingClasses] call FUNC(countItem);

if (GVAR(requireNVG) && {(hmd _unit) == ""}) then {
    _missing pushBack "NVGs";
    _missingClasses pushBack ["#belt", ["ACE_NVG_Wide"], 1];
};

if ((_unit getSlotItemName SLOT_MAP) isEqualTo "") then {
    _missing pushBack "A Map";
    _missingClasses pushBack ["#belt", ["ItemMap"], 1];
};

if ((_unit getSlotItemName SLOT_GPS) isEqualTo "") then {
    _missing pushBack "A GPS";
    _missingClasses pushBack ["#belt", ["ItemAndroid"], 1];
};

if ((_unit getSlotItemName SLOT_COMPASS) isEqualTo "") then {
    _missing pushBack "A Compass";
    _missingClasses pushBack ["#belt", ["ItemCompass"], 1];
};

if ((_unit getSlotItemName SLOT_WATCH) isEqualTo "") then {
    _missing pushBack "A Watch";
    _missingClasses pushBack ["#belt", ["ItemWatch"], 1];
};

if (GVAR(requireShovel) && {!("ACE_EntrenchingTool" in _unitItems)}) then {
    _missing pushBack "An Entrenching Tool";
    _missingClasses pushBack ["#item", ["ACE_EntrenchingTool"], 1];
};

if (_missing isNotEqualTo []) then {
    _missing insert [0, ["Missing Basic Gear:"]];
};

[_missing, _missingClasses] select _returnClasses

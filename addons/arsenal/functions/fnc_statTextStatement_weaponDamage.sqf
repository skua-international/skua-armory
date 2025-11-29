#include "..\script_component.hpp"
#include "\z\ace\addons\arsenal\defines.hpp"

params ["", "_configWeapon"];

switch (ACEGVAR(arsenal,currentLeftPanel)) do {
    case IDC_buttonPrimaryWeapon: {
        private _primaryMag = primaryWeaponMagazine ACEGVAR(arsenal,center);
        [primaryWeapon ACEGVAR(arsenal,center), _primaryMag param [0, ""]]
    };
    case IDC_buttonHandgun: {
        private _primaryMag = handgunMagazine ACEGVAR(arsenal,center);
        [handgunWeapon ACEGVAR(arsenal,center), _primaryMag param [0, ""]]
    };
    case IDC_buttonSecondaryWeapon: {
        private _primaryMag = secondaryWeaponMagazine ACEGVAR(arsenal,center);
        [secondaryWeapon ACEGVAR(arsenal,center), _primaryMag param [0, ""]]
    };
    default {["", ""]}
} params ["_weapon", "_magazine"];

if (_magazine isEqualTo "") exitWith {
    0
};

private _magazineConfig = configFile >> "CfgMagazines" >> _magazine;
private _cfgAmmo = configFile >> "CfgAmmo";
private _ammoConfig = _cfgAmmo >> (getText (_magazineConfig >> "ammo"));
private _simulation = getText (_ammoConfig >> "simulation");
private _hit = getNumber (_ammoConfig >> "hit");

if (_simulation != "shotBullet") exitWith {
    private _submunition = getText (_ammoConfig >> "submunitionAmmo");
    if (_submunition != "") then {
        _hit = getNumber (_cfgAmmo >> _submunition >> "hit");
    };
    _hit toFixed 2 // return
};

private _muzzleVelocity = ["", _magazineConfig] call FUNC(getMagazineMuzzleVelocity);
private _typicalSpeed = getNumber (_ammoConfig >> "typicalSpeed");

(_hit * (_muzzleVelocity / _typicalSpeed)) toFixed 2

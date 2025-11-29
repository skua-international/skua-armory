#include "..\script_component.hpp"

params ["", "_magazineConfig"];

private _cfgAmmo = configFile >> "CfgAmmo";
private _ammoConfig = _cfgAmmo >> (getText (_magazineConfig >> "ammo"));
private _simulation = getText (_ammoConfig >> "simulation");
private _penDepth = 0;

if (_simulation != "shotBullet") exitWith {
    private _submunition = getText (_ammoConfig >> "submunitionAmmo");
    if (_submunition != "") then {
        _penDepth = (getNumber (_cfgAmmo >> _submunition >> "caliber")) * 15;
        format ["%1 mm (%2 in)", _penDepth toFixed 2, (_penDepth/25.4) toFixed 2] // return
    } else {
        localize "STR_A3_None";
    };
};

private _caliber = getNumber (_ammoConfig >> "caliber");
private _muzzleVelocity = _this call FUNC(getMagazineMuzzleVelocity);

private _penDepth = _caliber * _muzzleVelocity * 0.015;

format ["%1 mm (%2 in)", _penDepth toFixed 2, (_penDepth/25.4) toFixed 2] // return

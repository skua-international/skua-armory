#include "..\script_component.hpp"

params ["", "_magazineConfig"];

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

private _muzzleVelocity = _this call FUNC(getMagazineMuzzleVelocity);

private _typicalSpeed = getNumber (_ammoConfig >> "typicalSpeed");

(_hit * (_muzzleVelocity / _typicalSpeed)) toFixed 2 // return

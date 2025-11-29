#include "..\script_component.hpp"
#include "\z\ace\addons\arsenal\defines.hpp"

params ["", "_magazineConfig"];

private _weapon = switch (ACEGVAR(arsenal,currentLeftPanel)) do {
    case IDC_buttonPrimaryWeapon: {
        primaryWeapon ACEGVAR(arsenal,center)
    };
    case IDC_buttonHandgun: {
        handgunWeapon ACEGVAR(arsenal,center)
    };
    case IDC_buttonSecondaryWeapon: {
        secondaryWeapon ACEGVAR(arsenal,center)
    };
    default {""}
};

// we might be looking at random mags not related to our weapon
private _magIsForCurrentWeapon = _weapon canAdd (configName _magazineConfig);
private _configWeapon = configNull;

private _muzzleVelocity = getNumber (_magazineConfig >> "initSpeed");
private _initSpeedCoef = 0;
if (_magIsForCurrentWeapon) then {
    _configWeapon = configFile >> "CfgWeapons" >> _weapon;
    _initSpeedCoef = getNumber (_configWeapon >> "initSpeed");
};
if (_initSpeedCoef < 0) then {
    _muzzleVelocity = _muzzleVelocity * -_initSpeedCoef;
};
if (_initSpeedCoef > 0) then {
    _muzzleVelocity = _initSpeedCoef;
};

if (
    _magIsForCurrentWeapon &&
    {ACEGVAR(arsenal,currentLeftPanel) != IDC_buttonSecondaryWeapon} &&
    {missionNamespace getVariable [QACEGVAR(advanced_ballistics,enabled), false]} &&
    {missionNamespace getVariable [QACEGVAR(advanced_ballistics,barrelLengthInfluenceEnabled), false]} // this can be on while AB is off or vice-versa
) then {
    private _configAmmo = (configFile >> "CfgAmmo" >> (getText (_magazineConfig >> "ammo")));
    private _barrelLength = getNumber (_configWeapon >> "ACE_barrelLength");
    private _muzzleVelocityTable = getArray (_configAmmo >> "ACE_muzzleVelocities");
    private _barrelLengthTable = getArray (_configAmmo >> "ACE_barrelLengths");
    private _abShift = [_barrelLength, _muzzleVelocityTable, _barrelLengthTable, 0] call ACEFUNC(advanced_ballistics,calculateBarrelLengthVelocityShift);
    if (_abShift != 0) then {
        _muzzleVelocity = _abShift;
    };
};

_muzzleVelocity

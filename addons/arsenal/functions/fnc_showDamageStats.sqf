#include "..\script_component.hpp"
#include "\z\ace\addons\arsenal\defines.hpp"

params ["", "_magazineConfig"];

private _ammoConfig = configFile >> "CfgAmmo" >> (getText (_magazineConfig >> "ammo"));
private _simulation = getText (_ammoConfig >> "simulation");

["shotBullet", "shotShell", "shotRocket", "shotMissile", "shotSpread"] findIf {_simulation == _x} != -1

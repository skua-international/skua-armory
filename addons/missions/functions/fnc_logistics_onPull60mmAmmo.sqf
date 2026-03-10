#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Handles pulling 60mm Mortar Ammo Box.
 *
 * Arguments:
 * 0: Box  <OBJECT>
 *
 * Return Value:
 * None.
 *
 * Example:
 * cursorTarget call skua_missions_fnc_logistics_onPull60mmAmmo;
 *
 * Public: No
 */

params ["_object"];
TRACE_1("fnc_logistics_onPull60mmAmmo",_this);

[{
    // Clear inventory
    clearMagazineCargoGlobal _this;
    clearWeaponCargoGlobal _this;
    clearItemCargoGlobal _this;
    clearBackpackCargoGlobal _this;

    // Add 60mm ammo
    _this addMagazineCargoGlobal ["avm224_M_6Rnd_60mm_HE_0_csw", 12];
    _this addMagazineCargoGlobal ["avm224_M_6Rnd_60mm_HE_csw", 12];
    _this addMagazineCargoGlobal ["avm224_M_6Rnd_60mm_ILLUM_IR_csw", 4];
    _this addMagazineCargoGlobal ["avm224_M_6Rnd_60mm_ILLUM_csw", 4];
    _this addMagazineCargoGlobal ["avm224_M_6Rnd_60mm_SMOKE_csw", 12];
}, _object] call CBA_fnc_execNextFrame;

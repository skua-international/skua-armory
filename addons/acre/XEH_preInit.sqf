#include "script_component.hpp"
#include "\z\ace\addons\arsenal\defines.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (isNil {uiNamespace getVariable QGVAR(radios)}) then {
    private _radioCond = toString {
        getNumber (_x >> "acre_isRadio") == 1 &&
        {getText (_x >> "baseWeapon") == (configName _x)}
    };
    private _radios = (_radioCond configClasses (configFile >> "CfgWeapons")) apply {configName _x};
    uiNamespace setVariable [QGVAR(radios), _radios];
};
[(uiNamespace getVariable QGVAR(radios)) + ["ACRE_VHF30108MAST", "ACRE_VHF30108SPIKE", "ACRE_VHF30108"], "Radios", "\A3\Ui_f\data\GUI\Rsc\RscDisplayArsenal\Radio_ca.paa"] call ACEFUNC(arsenal,addRightPanelButton);

ADDON = true;

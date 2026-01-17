#include "script_component.hpp"

[QACEGVAR(medical,fatalInjury), {
    params ["_unit"];
    if (_unit isNotEqualTo ACE_player) exitWith {};
    if !(GVAR(preventInstantDeath)) exitWith {};

    if (ACE_player getVariable QACEGVAR(medical,bloodVolume) > ACEGVAR(medical,_const_stableVitalsBloodThreshold)) exitWith {
        [{
            [QACEGVAR(medical,CPRSucceeded), ACE_player] call CBA_fnc_localEvent
        }] call CBA_fnc_execNextFrame;
    };
}] call CBA_fnc_addEventHandler;

[QACEGVAR(medical_treatment,cprLocal), {
    params ["", "_patient"];
    
    if !(_patient isNil QACEGVAR(medical_statemachine,cardiacArrestTimeLeft)) then {
        _patient call FUNC(resetCardiacArrestTime);
    };
}] call CBA_fnc_addEventHandler;

private _medicalVehicleAction = [QGVAR(vehicleAction), "Make Medical Vehicle", "\z\ace\addons\medical_gui\ui\cross.paa", {
    _target setVariable [QACEGVAR(medical,isMedicalVehicle), true, true]
}, {
    !(_target getVariable [QACEGVAR(medical,isMedicalVehicle), false]) &&
    {!(unitIsUAV _target)} &&
    {
        ACE_Player getVariable [QACEGVAR(medical,medicClass), 0] isEqualTo 2
    }
}] call ACEFUNC(interact_menu,createAction);

["Car", 0, ["ACE_MainActions"], _medicalVehicleAction, true] call ACEFUNC(interact_menu,addActionToClass);
["Tank", 0, ["ACE_MainActions"], _medicalVehicleAction, true] call ACEFUNC(interact_menu,addActionToClass);
["Helicopter", 0, ["ACE_MainActions"], _medicalVehicleAction, true] call ACEFUNC(interact_menu,addActionToClass);
["Ship", 0, ["ACE_MainActions"], _medicalVehicleAction, true] call ACEFUNC(interact_menu,addActionToClass);

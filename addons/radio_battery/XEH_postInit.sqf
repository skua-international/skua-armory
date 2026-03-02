#include "script_component.hpp"

GVAR(map) = createHashMap;

if (isServer) then {
    GVAR(masterMap) = createHashMap;

    [QGVAR(clientUpdate), {
        params ["_sender", "_radio", "_batteryLevel"];

        GVAR(masterMap) set [_radio, _batteryLevel];
    }] call CBA_fnc_addEventHandler;
};

["acre_startedSpeaking", {
    params ["_unit", "_onRadio", "_id", "_speakingType"];

    if (!_onRadio) exitWith {};

    // Get the radio's transmit power
    private _baseRadio = _radio call acre_api_fnc_getBaseRadio;
    private _transmitPower = configFile >> "CfgWeapons" >> _baseRadio >> "acre_arsenalStats_transmitPower";

    // Get current time
    // Assume we only have one outbound radio transmission at once
    GVAR(transmitStart) = diag_tickTime;

    // Start draining battery
    GVAR(transmitPFH) = [_radio, _transmitPower] call FUNC(transmitBatteryDrain);
}] call CBA_fnc_addEventHandler;

["acre_stoppedSpeaking", {
    params ["_unit", "_onRadio", "_id", "_speakingType"];

    if (!_onRadio) exitWith {};

    // Stop draining battery
    if (isNil QGVAR(transmitPFH)) exitWith {};
    GVAR(transmitPFH) call CBA_fnc_removePerFrameHandler;
    GVAR(transmitPFH) = nil;
}] call CBA_fnc_addEventHandler;

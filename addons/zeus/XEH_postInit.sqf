#include "script_component.hpp"

if (isServer) then {
    GVAR(channel) = radioChannelCreate [[248/256,148/256,6/256,1], "Zeus Chat", "Zeus (%UNIT_NAME)", [], false];
};

// Show the chat hint and add to the Zeus channel
[QACEGVAR(zeus,zeusUnitAssigned), {
    params ["_logic", "_unit"];

    systemChat format ["Zeus Module assigned to %1", name _unit];

    if (isServer) then {
        GVAR(channel) radioChannelAdd [_unit];
    };
}] call CBA_fnc_addEventHandler;

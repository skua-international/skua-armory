#include "script_component.hpp"

if (!isMultiplayer) exitWith {};

if (hasInterface) then {
    [QGVAR(loadPlayer), [player]] call CBA_fnc_serverEvent;
};

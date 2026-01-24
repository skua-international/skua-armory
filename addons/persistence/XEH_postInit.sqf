#include "script_component.hpp"

if (!isMultiplayer) exitWith {};

if (hasInterface) then {
    player call FUNC(request_loadPlayerData);
};

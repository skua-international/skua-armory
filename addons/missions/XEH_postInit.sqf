#include "script_component.hpp"

if (isServer) then {
    // Don't create base arsenal if it already exists
    // This lets mission makers create the base arsenal with a limited selection themselves if they want to
    if (isNil QGVAR(baseArsenal)) then {
        GVAR(baseArsenal) = createVehicle ["Land_HelipadEmpty_F", [0, 0, 0], [], 0, "NONE"];
        [GVAR(baseArsenal), true, true] call ACEFUNC(arsenal,initBox);
    };
};

#include "script_component.hpp"

if (isServer) then {
    // Don't create base arsenal if it already exists
    // This lets mission makers create the base arsenal with a limited selection themselves if they want to
    {
        if (!isNull _y) then {
            continue;
        };

        GVAR(baseArsenals) set [_x, createVehicle ["Land_HelipadEmpty_F", [0, 0, 0], [], 0, "NONE"]];

        [GVAR(baseArsenals) get _x, true, true] call ACEFUNC(arsenal,initBox);
    } forEach GVAR(baseArsenals);

    publicVariable QGVAR(baseArsenals); // make sure to sync
};

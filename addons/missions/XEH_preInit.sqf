#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

GVAR(arsenalAreas) = createHashMapFromArray [
    [west, []],
    [east, []],
    [resistance, []],
    [civilian, []]
];

GVAR(baseArsenals) = createHashMapFromArray [
    [west, objNull],
    [east, objNull],
    [resistance, objNull],
    [civilian, objNull]
];

ADDON = true;

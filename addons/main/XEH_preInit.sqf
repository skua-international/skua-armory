#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Set up extension logging
addMissionEventHandler ["ExtensionCallback", {
    params ["_name", "_component", "_data"];
    if ((toLower _name) != "skua_ext_log") exitWith {};
    (parseSimpleArray _data) params ["_level", "_message"];
    diag_log text format ["[SKUA EXTENSION] (%1) %2: %3", _component, _level, _message];
}];

ADDON = true;

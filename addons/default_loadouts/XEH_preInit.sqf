#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (isServer) then { // Server adds the default loadouts globally
    ["[Skua] Rifleman Base - Vanilla + ACE", VANILLA_RIFLEMAN_BASE_LOADOUT, true] call ACEFUNC(arsenal,addDefaultLoadout);
    // Temperate -> "Green" maps
    ["[Skua] Rifleman Base - Skua Modset - Temperate", SKUA_RIFLEMAN_BASE_TEMPERATE_LOADOUT, true] call ACEFUNC(arsenal,addDefaultLoadout);
    // Arid -> "Yellow" maps
    ["[Skua] Rifleman Base - Skua Modset - Arid", SKUA_RIFLEMAN_BASE_ARID_LOADOUT, true] call ACEFUNC(arsenal,addDefaultLoadout);
};

ADDON = true;

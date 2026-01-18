#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

if (isServer) then { // Server adds the default loadouts globally
    ["[Skua] Rifleman - Vanilla", VANILLA_RIFLEMAN_BASE_LOADOUT, true] call ACEFUNC(arsenal,addDefaultLoadout);
    // Temperate -> "Green" maps
    ["[Skua] Rifleman - Modded - Temperate", SKUA_RIFLEMAN_BASE_TEMPERATE_LOADOUT, true] call ACEFUNC(arsenal,addDefaultLoadout);
    // Arid -> "Yellow" maps
    ["[Skua] Rifleman - Modded - Arid", SKUA_RIFLEMAN_BASE_ARID_LOADOUT, true] call ACEFUNC(arsenal,addDefaultLoadout);
    // Semi-Arid -> Altis, Stratis
    ["[Skua] Rifleman - Modded - Semi-Arid", SKUA_RIFLEMAN_BASE_SEMIARID_LOADOUT, true] call ACEFUNC(arsenal,addDefaultLoadout);
};

ADDON = true;

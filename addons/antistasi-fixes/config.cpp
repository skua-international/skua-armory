#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "skua_main",
            "A3A_core", // Present on CE/Ultimate/TEH alike - just used to gate loading to an Antistasi mission at all. The loot-crate-classname lookups below are all runtime/dynamic (A3A_faction_reb get "lootCrate") specifically so this addon doesn't need to hardcode a classname that differs - or is entirely absent, on CE - per variant.
            "ace_dragging"
        };
        skipWhenMissingDependencies = 1;
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

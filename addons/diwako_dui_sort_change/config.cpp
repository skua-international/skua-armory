#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "skua_main",
            "diwako_dui_radar"
        };
        skipWhenMissingDependencies = 1;
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

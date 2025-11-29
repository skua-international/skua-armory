#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {
            "APM_large_box",
            "APM_large_crate"
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "skua_main"
        };
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
    class APM_boxMod {
        addonRootClass = QUOTE(ADDON);
        name = COMPONENT_NAME;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"

#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "ace_medical",
            "ace_refuel",
            "skua_main",
            "skua_common"
        };
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "CfgDebriefing.hpp"
#include "CfgEventHandlers.hpp"

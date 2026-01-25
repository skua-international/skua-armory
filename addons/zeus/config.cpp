#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "skua_main",
            "skua_common",
            "ace_zeus",
            "zen_modules",
            "zen_context_menu"
        };
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "ACE_ZeusActions.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgContext.hpp"

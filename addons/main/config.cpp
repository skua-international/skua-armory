#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "A3_Data_F_Oldman_Loadorder",
            "ace_smallarms",
            "ace_grenades",
            "ace_attach",
            "ace_medical",
            "ace_advanced_ballistics",
            "ace_interaction",
            "ace_zeus",
            "zen_modules"
        };
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgSettings.hpp"

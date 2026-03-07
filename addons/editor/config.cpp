#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"skua_main"};
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;       
    };
};

#include "CfgEventHandlers.hpp"
#include "Display3DEN.hpp"

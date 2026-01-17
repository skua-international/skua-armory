#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "skua_main",
            "skua_common"
        };
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgDebriefing.hpp"

enableDebugConsole[] = { // TODO: Replace with database lookup at runtime
    "76561198027717871", //Picker
    "76561198146199462"  //Link
};

cba_settings_whitelist[] = { // Do not replace with database lookup at runtime
    "76561198027717871", //Picker
    "76561198146199462"  //Link
};

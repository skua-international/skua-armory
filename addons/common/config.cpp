#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {
            QCLASS(module),
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
    class tac_main {
        addonRootClass = QUOTE(ADDON);
        name = "TAC Main";
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

enableTargetDebug = 1;

class CBA_Extended_EventHandlers;

#include "CfgVehicles.hpp"
#include "CfgEditorCategories.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "ui\RscModal.hpp"

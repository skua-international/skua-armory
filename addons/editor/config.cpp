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
            "zen_context_menu",
            "acre_sys_zeus"
        };
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "Cfg3DEN.hpp"
#include "CfgEditorCategories.hpp"
#include "CfgEditorSubcategories.hpp"
#include "CfgEventHandlers.hpp"

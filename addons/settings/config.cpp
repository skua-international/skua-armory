#include "script_component.hpp"

class CfgPatches {
    class cba_settings_userconfig {
        name = "$STR_CBA_Settings_Component";
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_settings"};
        author = "$STR_CBA_Author";
        authors[] = {"commy2"};
        url = "$STR_CBA_URL";
        VERSION_CONFIG;
    };
};

// Prevents setting changes from persisting between server restarts on dedicated server
cba_settings_volatile = 1;

// Dummy: make HEMTT not complain about unused stringtable entries
skua_settings_unused[] = {
    "$STR_cba_keybinding_configureaddons",
    "$STR_cba_settings_configureaddons",
    "$STR_cba_settings_menu_button"
};

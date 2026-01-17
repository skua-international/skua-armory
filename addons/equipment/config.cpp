#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {
            QCLASS(U_classic_odblk_cwg),
            QCLASS(U_classic_odblk_rs),
            QCLASS(U_classic_odblk),
            QCLASS(U_classic_odtan_cwg),
            QCLASS(U_classic_odtan_rs),
            QCLASS(U_classic_odtan),
            QCLASS(Shemagh_Black_NVG),
            QCLASS(Shemagh_Coyote_NVG),
            QCLASS(Shemagh_Olive_NVG)
        };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "skua_main"
        };
        author = "LinkIsGrim";
        name = COMPONENT_NAME;
        VERSION_CONFIG;
    };
};

#include "CfgGlasses.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"

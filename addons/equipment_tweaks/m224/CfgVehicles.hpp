class CfgVehicles {
    class Bag_Base;
    // Fix the backpack to spawn the correct mortar variant
    class NDS_B_M224_mortar: Bag_Base {
        class assembleInfo {
            assembleTo = "avm224_M224_mortar";
        };
    };
    
    class StaticMortar;
    class Mortar_01_base_F : StaticMortar {
        class ace_csw;
    };
    // Enable fire on load for the 60mm CSW variant
    class NDS_M224_mortar_base: Mortar_01_base_F {
        class EventHandlers {
            GetIn = "if (local (_this select 0)) then {(_this select 0) animatesource [""foldweapon"",1];}";
            GetOut = "if (local (_this select 0)) then {(_this select 0) animatesource [""foldweapon"",1];}";
        };
        class ace_csw: ace_csw {
            allowFireOnLoad = 1;
            ammoLoadTime = 0.5;
            ammoUnloadTime = 0.5;
            proxyWeapon = "avm224_W_M224_mortar_proxy";
            disassembleTo = "avm224_W_M224_mortar_carry";
        };
    };

    class NDS_M224_mortar;
    class avm224_M224_mortar: NDS_M224_mortar {
        class ace_csw {
            allowFireOnLoad = 1;
            ammoLoadTime = 0.5;
            ammoUnloadTime = 0.5;
            // proxyWeapon = "avm224_W_M224_mortar_proxy";
            // disassembleTo = "avm224_W_M224_mortar_carry";
        };
    };
};

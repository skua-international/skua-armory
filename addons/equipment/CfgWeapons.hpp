class CfgWeapons {
    class NVGoggles;
    class ACE_NVG_Wide: NVGoggles {
        class ItemInfo;
    };
    class CLASS(Shemagh_Black_NVG): ACE_NVG_Wide {
        author = "GhostIsSpooky";
        scope = 2;
        displayName = "[SIA] Scarf + NVG (Black)";
        picture = QPATHTOF(data\logo.paa);
        hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\Shemagh_Black_co.paa)};
        class ItemInfo: ItemInfo {
            modelOff = QPATHTOF(data\G_Shemagh.p3d);
            hiddenSelections[] = {"camo"};
        };
    };
    class CLASS(Shemagh_Olive_NVG): CLASS(Shemagh_Black_NVG) {
        displayName = "[SIA] Scarf + NVG (Olive)";
        hiddenSelectionsTextures[] = {QPATHTOF(data\Shemagh_Olive_co.paa)};
    };
    class CLASS(Shemagh_Coyote_NVG): CLASS(Shemagh_Black_NVG) {
        displayName = "[SIA] Scarf + NVG (Coyote)";
        hiddenSelectionsTextures[] = {QPATHTOF(data\do_equip_co.paa)};
    };
    class ItemCore;
    class Uniform_Base: ItemCore {
        class ItemInfo;
    };
    class CLASS(U_classic_odtan): Uniform_Base {
        scope = 2;
        displayName = "[SIA] Classic Uniform (OD/Tan)";
        picture = QPATHTOF(data\logo.paa);
        class ItemInfo: ItemInfo {
            mass = 40;
            containerClass = "Supply40";
            uniformClass = QCLASS(U_classic_odtan_unit);
        };
    };
    class CLASS(U_classic_odtan_rs): Uniform_Base {
        scope = 2;
        displayName = "[SIA] Classic Uniform RS (OD/Tan)";
        picture = QPATHTOF(data\logo.paa);
        class ItemInfo: ItemInfo {
            mass = 40;
            containerClass = "Supply40";
            uniformClass = QCLASS(U_classic_odtan_rs_unit);
        };
    };
    class CLASS(U_classic_odtan_cwg): Uniform_Base {
        scope = 2;
        displayName = "[SIA] Classic Uniform CWG (OD/Tan)";
        picture = QPATHTOF(data\logo.paa);
        class ItemInfo: ItemInfo {
            mass = 40;
            containerClass = "Supply40";
            uniformClass = QCLASS(U_classic_odtan_cwg_unit);
        };
    };
    class CLASS(U_classic_odblk): Uniform_Base {
        scope = 2;
        displayName = "[SIA] Classic Uniform (OD/Black)";
        picture = QPATHTOF(data\logo.paa);
        class ItemInfo: ItemInfo {
            mass = 40;
            containerClass = "Supply40";
            uniformClass = QCLASS(U_classic_odblk_unit);
        };
    };
    class CLASS(U_classic_odblk_rs): Uniform_Base {
        scope = 2;
        displayName = "[SIA] Classic Uniform RS (OD/Black)";
        picture = QPATHTOF(data\logo.paa);
        class ItemInfo: ItemInfo {
            mass = 40;
            containerClass = "Supply40";
            uniformClass = QCLASS(U_classic_odblk_rs_unit);
        };
    };
    class CLASS(U_classic_odblk_cwg): Uniform_Base {
        scope = 2;
        displayName = "[SIA] Classic Uniform CWG (OD/Black)";
        picture = QPATHTOF(data\logo.paa);
        class ItemInfo: ItemInfo {
            mass = 40;
            containerClass = "Supply40";
            uniformClass = QCLASS(U_classic_odblk_cwg_unit);
        };
    };
};

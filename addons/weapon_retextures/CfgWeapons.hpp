class CfgWeapons {
    // Tropic Noreen "Bad News" ULR
    class srifle_DMR_02_F;
    class srifle_DMR_02_tna_F: srifle_DMR_02_F {
        displayName = CSTRING(DMR_02_tna_Name);
        hiddenSelectionsTextures[] = {
            QPATHTOF(data\dmr_02\DMR_02_01_tna_CO.paa),
            QPATHTOF(data\dmr_02\DMR_02_02_tna_CO.paa)
        };
        picture = QPATHTOF(data\dmr_02\icon_srifle_DMR_02_tna_F_X_CA.paa);
        baseWeapon = QUOTE(srifle_DMR_02_tna_F);
    };

    // Green Hex Cyrus
    class srifle_DMR_05_blk_F;
    class srifle_DMR_05_ghex_F: srifle_DMR_05_blk_F {
        displayName = CSTRING(DMR_05_ghex_Name);
        hiddenSelectionsTextures[] = {
            QPATHTOF(data\dmr_05\DMR_05_01_ghex_CO.paa),
            QPATHTOF(data\dmr_05\DMR_05_02_ghex_CO.paa)
        };
        picture = QPATHTOF(data\dmr_05\icon_srifle_DMR_05_ghex_F_X_CA.paa);
        baseWeapon = QUOTE(srifle_DMR_05_ghex_F);
    };

    // MX Retextures
    class arifle_MX_Base_F;
    class arifle_MX_F: arifle_MX_Base_F {
        hiddenSelections[] = {"camo1","camo2"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_co.paa), QPATHTOF(data\mx\XMX_short_co.paa)};
    };
    class arifle_MX_Black_F: arifle_MX_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_blk_co.paa), QPATHTOF(data\mx\XMX_short_blk_co.paa)};
    };
    class arifle_MX_khk_F: arifle_MX_Black_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_khk_co.paa), QPATHTOF(data\mx\XMX_short_khk_co.paa)};
    };
    class arifle_MXC_F: arifle_MX_Base_F {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_short_co.paa)};
    };
    class arifle_MXC_Black_F: arifle_MXC_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_short_blk_co.paa)};
    };
    class arifle_MXC_khk_F: arifle_MXC_Black_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_short_khk_co.paa)};
    };
    class arifle_MX_GL_F: arifle_MX_Base_F {
        hiddenSelections[] = {"camo1","camo2"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_co.paa), QPATHTOF(data\mx\GLX_co.paa)};
    };
    class arifle_MX_GL_Black_F: arifle_MX_GL_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_blk_co.paa), QPATHTOF(data\mx\GLX_co.paa)};
    };
    class arifle_MX_GL_khk_F: arifle_MX_GL_Black_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Base_khk_co.paa), QPATHTOF(data\mx\GLX_co.paa)};
    };
    class arifle_MX_SW_F: arifle_MX_Base_F {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_co.paa)};
    };
    class arifle_MX_SW_Black_F: arifle_MX_SW_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_blk_co.paa)};
    };
    class arifle_MX_SW_khk_F: arifle_MX_SW_Black_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_LMG_khk_co.paa)};
    };
    class arifle_MXM_F: arifle_MX_Base_F {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Long_co.paa)};
    };
    class arifle_MXM_Black_F: arifle_MXM_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Long_blk_co.paa)};
    };
    class arifle_MXM_khk_F: arifle_MXM_Black_F {
        hiddenSelectionsTextures[] = {QPATHTOF(data\mx\XMX_Long_khk_co.paa)};
    };

    class Pistol_Base_F;

    // Custom Covert II retextures
    class hgun_ACPC2_F;
    class ACPC2_classic_F: hgun_ACPC2_F {
        displayName = CSTRING(ACPC2_classic_Name);
        hiddenSelectionsTextures[] = {QPATHTOF(data\acpc2\hgun_ACPC2_classic_co.paa)};
        picture = QPATHTOF(data\acpc2\icon_hgun_ACPC2_classic_F_X_CA.paa);
        baseWeapon = QUOTE(ACPC2_classic_F);
    };
    class ACPC2_black_F: hgun_ACPC2_F {
        displayName = CSTRING(ACPC2_black_Name);
        hiddenSelectionsTextures[] = {QPATHTOF(data\acpc2\hgun_ACPC2_black_co.paa)};
        picture = QPATHTOF(data\acpc2\icon_hgun_ACPC2_black_F_X_CA.paa);
        baseWeapon = QUOTE(ACPC2_black_F);
    };

    // FNX-45 retextures
    class hgun_Pistol_heavy_01_green_F;
    class hgun_Pistol_heavy_01_black_F: hgun_Pistol_heavy_01_green_F {
        displayName = CSTRING(Pistol_Heavy_01_black_Name);
        hiddenSelectionsTextures[] = {QPATHTOF(data\pistol_heavy_01\hgun_Pistol_Heavy_01_black_co.paa)};
        picture = QPATHTOF(data\pistol_heavy_01\icon_hgun_Pistol_heavy_01_black_F_X_ca.paa);
        baseWeapon = QUOTE(hgun_Pistol_heavy_01_black_F);
    };

    // M200 Intervention retextures
    class srifle_LRR_camo_F;
    class srifle_LRR_sand_F: srifle_LRR_camo_F {
        displayName = CSTRING(LRR_sand_Name);
        hiddenSelectionsTextures[] = {QPATHTOF(data\m200\srifle_M200_sand_F.paa)};
        baseWeapon = QUOTE(srifle_LRR_sand_F);
    };

    // Negev NG7R retextures
    class LMG_Zafir_F;
    class LMG_Zafir_blk_F: LMG_Zafir_F {
        displayName = CSTRING(LMG_Zafir_blk_Name);
        hiddenSelectionsTextures[] = {
            QPATHTOF(data\lmg_zafir\LMG_Zafir_blk_F_01_CO.paa),
            QPATHTOF(data\lmg_zafir\LMG_Zafir_blk_F_02_CO.paa)
        };
        picture = QPATHTOF(data\lmg_zafir\icon_LMG_Zafir_black_F_X_ca.paa);
        baseWeapon = QUOTE(LMG_Zafir_blk_F);
    };

    // HK121 retextures
    class MMG_01_hex_F;
    class MMG_01_black_F: MMG_01_hex_F {
        displayName = CSTRING(MMG_01_black_Name);
        hiddenSelectionsTextures[] = {
            QPATHTOF(data\mmg_01\MMG_01_01_black_CO.paa),
            QPATHTOF(data\mmg_01\MMG_01_02_black_CO.paa),
            QPATHTOF(data\mmg_01\MMG_01_03_black_CO.paa)
        };
        picture = QPATHTOF(data\mmg_01\icon_MMG_01_black_F_X_CA.paa);
        baseWeapon = QUOTE(MMG_01_black_F);
        class LinkedItems {
            class LinkedItemsUnder {
                slot = "UnderBarrelSlot";
                item = "bipod_02_F_blk";
            };
        };
    };
};

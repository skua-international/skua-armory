class CfgVehicles {

    // Tee Retextures
    class B_Soldier_F;
    //"a3\Characters_F_Enoch\Uniforms\Data\basicbody_wdl_co.paa"
    class VSM_Scorpion_Crye_Tee_Uniform: B_Soldier_F {
        hiddenSelections[] = {"camo","camo2"};
        hiddenSelectionsTextures[] = {"\VSM_Scorpion\Data\VSM_ARD_Scorpion_1.paa","\a3\Characters_F_Enoch\Uniforms\Data\basicbody_wdl_co.paa"};
    };
    class VSM_Multicam_Crye_Tee_Uniform: B_Soldier_F {
        hiddenSelections[] = {"camo","camo2"};
        hiddenSelectionsTextures[] = {"\VSM_Multicam\Data\VSM_ARD_Multicam_1.paa","\a3\Characters_F_Enoch\Uniforms\Data\basicbody_wdl_co.paa"};
    };
    class AOR_2_Crye_Tee_Uniform: B_Soldier_F {
        hiddenSelections[] = {"camo","camo2"};
        hiddenSelectionsTextures[] = {"\AOR_2\data\AOR_2.paa","\a3\Characters_F_Enoch\Uniforms\Data\basicbody_wdl_co.paa"};
    };
    //"\A3\Characters_F_Exp\BLUFOR\Data\U_BT_Soldier_AR_F_tna_01_co.paa"
    class VSM_MulticamTropic_Crye_Tee_Uniform: B_Soldier_F {
        hiddenSelections[] = {"camo","camo2"};
        hiddenSelectionsTextures[] = {"\VSM_MulticamTropic\Data\VSM_ARD_MulticamTropic_1.paa","\A3\Characters_F_Exp\BLUFOR\Data\U_BT_Soldier_AR_F_tna_01_co.paa"};
    };
    //"\a3\Characters_F\Common\Data\basicbody_black_co.paa"
    class VSM_M81_Crye_Tee_Uniform: B_Soldier_F {
        hiddenSelections[] = {"camo","camo2"};
        hiddenSelectionsTextures[] = {"\VSM_M81\Data\VSM_ARD_M81_1.paa","\a3\Characters_F\Common\Data\basicbody_black_co.paa"};
    };
    class VSM_AOR1_Crye_Tee_Uniform: B_Soldier_F {
        hiddenSelections[] = {"camo","camo2"};
        hiddenSelectionsTextures[] = {"\VSM_AOR1\Data\VSM_ARD_AOR1_1.paa","\a3\Characters_F\Common\Data\basicbody_black_co.paa"};
    };

    // Expanded Assault Packs
    class B_AssaultPack_Kerry;
    class B_AssaultPackSpec_OD: B_AssaultPack_Kerry {
        picture = "\VSM_OGA\Data\Icons\VSM_OGA_OD.paa";
        displayName = "Assault Pack (OD, Expanded)";
        hiddenSelectionsTextures[] = {"\VSM_OGA\Data\VSM_OGA_OD_compact.paa","\VSM_OGA\Data\VSM_OGA_OD_Vest.paa"};
    };
    class B_AssaultPackSpec_blk: B_AssaultPack_Kerry {
        picture = "\MLO_Ghost\Data\Icons\VSM_Black.paa";
        displayName = "Assault Pack (Black, Expanded)";
        hiddenSelectionsTextures[] = {"\MLO_Ghost\Data\VSM_black_compact.paa","\MLO_Ghost\Data\VSM_Black_Vest.paa"};
    };
    class B_AssaultPackSpec_cbr: B_AssaultPack_Kerry {
        picture = "\A3\Weapons_F\Ammoboxes\Bags\data\UI\icon_B_AssaultPack_cbr_ca.paa";
        displayName = "Assault Pack (Coyote, Expanded)";
        hiddenSelectionsTextures[] = {"\A3\weapons_f\ammoboxes\bags\data\backpack_compact_cbr_co.paa", "\A3\Characters_F\BLUFOR\Data\vests_cbr_co.paa"};
    };
    class B_AssaultPackSpec_tan: B_AssaultPack_Kerry {
        picture = "\VSM_OGA\Data\Icons\VSM_OGA.paa";
        displayName = "Assault Pack (Tan, Expanded)";
        hiddenSelectionsTextures[] = {"\VSM_OGA\Data\VSM_OGA_compact.paa","\VSM_OGA\Data\VSM_OGA_Vest.paa"};
    };

    // Rename VSM backpacks
    class B_AssaultPack_Base;
    class MLO_Black_Backpack_AssaultPack: B_AssaultPack_Base {
        displayName = "Assault Pack (Black)";
    };
    class B_Kitbag_Base;
    class MLO_Black_Backpack_Kitbag: B_Kitbag_Base {
        displayName = "Kitbag (Black)";
    };
    class B_Carryall_Base;
    class MLO_Black_Backpack_Carryall: B_Carryall_Base {
        displayName = "Carryall Backpack (Black)";
    };
};

class CfgVehicles {
    class B_Soldier_F;
    class CLASS(U_classic_odtan_unit): B_Soldier_F {
        scope = 1;
        hiddenSelections[] = {"camo", "insignia"};
        hiddenSelectionsTextures[] = {QPATHTOF(data\classicuniform_odtan.paa)};
        hiddenSelectionsMaterials[] = {QPATHTOF(data\classicuniform.rvmat)};
    };
    class CLASS(U_classic_odtan_rs_unit): CLASS(U_classic_odtan_unit) {
        model = "\A3\characters_F\BLUFOR\b_soldier_03.p3d";
    };
    class CLASS(U_classic_odtan_cwg_unit): CLASS(U_classic_odtan_unit) {
        model = "\A3\Characters_F_Exp\BLUFOR\B_CTRG_Soldier_01_F.p3d";
    };
    class CLASS(U_classic_odblk_unit): CLASS(U_classic_odtan_unit) {
        hiddenSelectionsTextures[] = {QPATHTOF(data\classicuniform_odblk.paa)};
    };
    class CLASS(U_classic_odblk_rs_unit): CLASS(U_classic_odtan_rs_unit) {
        hiddenSelectionsTextures[] = {QPATHTOF(data\classicuniform_odblk.paa)};
    };
    class CLASS(U_classic_odblk_cwg_unit): CLASS(U_classic_odtan_cwg_unit) {
        hiddenSelectionsTextures[] = {QPATHTOF(data\classicuniform_odblk.paa)};
    };
};

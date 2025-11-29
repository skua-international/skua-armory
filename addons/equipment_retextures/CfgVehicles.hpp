class CfgVehicles {
    class B_TacticalPack_Base;
    class B_TacticalPack_rgr: B_TacticalPack_Base {
        hiddenSelectionsTextures[] = {QPATHTOF(data\backpack_small\backpack_small_rgr_CO.paa)};
        picture = QPATHTOF(data\backpack_small\icon_B_TacticalPack_rgr_ca.paa);
    };

    class B_ghillie_lsh_F;
    class B_W_ghillie_wdl_F: B_ghillie_lsh_F {
        scope = 1;
        uniformClass = "U_B_W_FullGhillie_wdl_F";
        hiddenSelectionsTextures[] = {QPATHTOF(data\ghillie\ghillie_coverall_NATO_CO.paa),QPATHTOF(data\ghillie\ghillie_threads_wdl_CA.paa),QPATHTOF(data\ghillie\ghillie_threads_5LOD_wdl_CO.paa)};
    };
    class B_ghillie_arc_F: B_ghillie_lsh_F {
        scope = 1;
        uniformClass = "U_B_FullGhillie_arc_F";
        hiddenSelectionsTextures[] = {QPATHTOF(data\ghillie\ghillie_coverall_NATO_arc_CO.paa),QPATHTOF(data\ghillie\ghillie_threads_arc_CA.paa),QPATHTOF(data\ghillie\ghillie_threads_5LOD_arc_CO.paa)};
    };
    class O_ghillie_lsh_F;
    class O_R_ghillie_wdl_F: O_ghillie_lsh_F {
        scope = 1;
        uniformClass = "U_O_R_FullGhillie_wdl_F";
        hiddenSelectionsTextures[] = {QPATHTOF(data\ghillie\ghillie_coverall_RUtaiga_CO.paa),QPATHTOF(data\ghillie\ghillie_threads_wdl_CA.paa),QPATHTOF(data\ghillie\ghillie_threads_5LOD_wdl_CO.paa)};
    };
    class O_ghillie_arc_F: O_ghillie_lsh_F {
        scope = 1;
        uniformClass = "U_O_FullGhillie_arc_F";
        hiddenSelectionsTextures[] = {QPATHTOF(data\ghillie\ghillie_coverall_RUS_arc_CO.paa),QPATHTOF(data\ghillie\ghillie_threads_arc_CA.paa),QPATHTOF(data\ghillie\ghillie_threads_5LOD_arc_CO.paa)};
    };
};

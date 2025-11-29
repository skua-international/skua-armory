class CfgVehicles {
    class B_Soldier_F;
    class APM_Hoodie_BlackBlue: B_Soldier_F {
        scope = 1;
        displayName = "Low profile operator";
        picture = "\lowprofile\logo.paa";
        uniformAccessories[] = {};
        nakedUniform = "U_BasicBody";
        model = "\lowprofile\models\lp4_2.p3d";
        weapons[] = {};
        respawnWeapons[] = {};
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\hoodie_black.paa"};
        hiddenSelectionMaterial[] = {};
    };
    class APM_Hoodie_BlackBlack: APM_Hoodie_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\hoodie_black.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Hoodie_GreenBlue: APM_Hoodie_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\hoodie_green.paa"};
    };
    class APM_Hoodie_GreenBlack: APM_Hoodie_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\hoodie_green.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Hoodie_GreyBlue: APM_Hoodie_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\Hoodie_grey_co.paa"};
    };
    class APM_Hoodie_GreyBlack: APM_Hoodie_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\Hoodie_grey_co.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Hoodie_TanBlue: APM_Hoodie_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\hoodie_tan.paa"};
    };
    class APM_Hoodie_TanBlack: APM_Hoodie_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\hoodie\Hoodie_tan.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Tee_BlackBlue: B_Soldier_F {
        scope = 1;
        displayName = "Low profile operator";
        picture = "\lowprofile\logo.paa";
        uniformAccessories[] = {};
        nakedUniform= "U_BasicBody";
        model= "\lowprofile\models\lp5_3.p3d";
        weapons[] = {};
        respawnWeapons[] = {};
        hiddenSelections[] = {};
        hiddenSelectionsTextures[] = {};
        hiddenSelectionMaterial[] = {};
    };
    class APM_Tee_BlackBlack: APM_Tee_BlackBlue {
        hiddenSelections[] = {"camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Tee_BlueBlue: APM_Tee_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\tshirt\tshirt_blue_co.paa"};
    };
    class APM_Tee_BlueBlack: APM_Tee_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\tshirt\tshirt_blue_co.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Tee_GreenBlue: APM_Tee_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\tshirt\tshirt_green_co.paa"};
    };
    class APM_Tee_GreenBlack: APM_Tee_BlackBlue {
        hiddenSelections[] = {"camo1","camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\tshirt\tshirt_green_co.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Tee_RedBlue: APM_Tee_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\tshirt\tshirt_red_co.paa"};
    };
    class APM_Tee_RedBlack: APM_Tee_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\tshirt\tshirt_red_co.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Jacket_BlackBlue: B_Soldier_F {
        scope = 1;
        displayName = "Low profile operator";
        picture = "\lowprofile\logo.paa";
        uniformAccessories[] = {};
        nakedUniform= "U_BasicBody";
        model= "\lowprofile\models\lpbom3.p3d";
        weapons[] = {};
        respawnWeapons[] = {};
        hiddenSelections[] = {};
        hiddenSelectionsTextures[] = {};
        hiddenSelectionMaterial[] = {};
    };
    class APM_Jacket_BlackBlack: APM_Jacket_BlackBlue {
        hiddenSelections[] = {"camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Jacket_BlueBlue: APM_Jacket_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\bomber\BomberJacket_blue_co.paa"};
    };
    class APM_Jacket_BlueBlack: APM_Jacket_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\bomber\BomberJacket_blue_co.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Jacket_OliveBlue: APM_Jacket_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\bomber\BomberJacket_Olive_co.paa"};
    };
    class APM_Jacket_OliveBlack: APM_Jacket_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\bomber\BomberJacket_Olive_co.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
    class APM_Jacket_RedBlue: APM_Jacket_BlackBlue {
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"\lowprofile\bomber\BomberJacket_red_co.paa"};
    };
    class APM_Jacket_RedBlack: APM_Jacket_BlackBlue {
        hiddenSelections[] = {"camo1", "camo2"};
        hiddenSelectionsTextures[] = {"\lowprofile\bomber\BomberJacket_red_co.paa", "\lowprofile\jean\jean2_brown.paa"};
    };
};

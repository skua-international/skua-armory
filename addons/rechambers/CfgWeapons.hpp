class CfgWeapons {
    class LMG_Zafir_F;
    class LMG_Negev_F: LMG_Zafir_F {
        displayName = "$STR_ACE_RealisticNames_LMG_Zafir_Name";
        descriptionShort = CSTRING(LMG_762x51_Desc_Short);
        baseWeapon = QUOTE(LMG_Negev_F);
        magazines[] = {"150Rnd_762x51_Box", "150Rnd_762x51_Box_Tracer"};
        magazineWell[] = {"CBA_762x51_LINKS"};
    };

    class Pistol_Base_F;
    class hgun_ACPC2_F: Pistol_Base_F {
        class WeaponSlotsInfo;
    };

    class hgun_9mmC2_F: hgun_ACPC2_F {
        displayName = CSTRING(9mmC2_Name);
        descriptionShort = "$STR_A3_CfgWeapons_hgun_P071";
        baseWeapon = QUOTE(9mmC2_F);
        magazines[] = {"16Rnd_9x21_Mag"};
        magazineWell[] = {"CBA_9x19_Walther", "Pistol_9x21"};
        class WeaponSlotsInfo: WeaponSlotsInfo {
            class MuzzleSlot: asdg_MuzzleSlot_9MM {};
        };
    };
};

class Mode_FullAuto;
class Mode_Burst;
class Mode_SemiAuto;

class CfgWeapons {
    class Rifle_Base_F;
    class Rifle_Long_Base_F: Rifle_Base_F {
        class WeaponSlotsInfo;
    };
    class LMG_Zafir_F: Rifle_Long_Base_F {
        displayName = CSTRING(LMG_Zafir_Name);
        modes[] += {"FullAutoFast"};
        class Single: Mode_SemiAuto {
            reloadTime = 0.1; // 60/600RPM
            class BaseSoundModeType;
            class SilencedSound: BaseSoundModeType {
                soundSetShot[] = {
                    "Zafir_silencerShot_SoundSet",
                    "Zafir_silencerTail_SoundSet",
                    "Zafir_silencerInteriorTail_SoundSet"
                };
            };
            sounds[] = {"StandardSound","SilencedSound"};
        };
        class FullAuto: Mode_FullAuto {
            reloadTime = 0.1;
            class BaseSoundModeType;
            class SilencedSound: BaseSoundModeType {
                soundSetShot[] = {
                    "Zafir_silencerShot_SoundSet",
                    "Zafir_silencerTail_SoundSet",
                    "Zafir_silencerInteriorTail_SoundSet"
                };
            };
            sounds[] = {"StandardSound","SilencedSound"};
        };
        class FullAutoFast: FullAuto {
            reloadTime = 0.08; // 60/750RPM
            textureType = "fastAuto";
        };
        class WeaponSlotsInfo: WeaponSlotsInfo {
            class MuzzleSlot: asdg_MuzzleSlot_762 {
                linkProxy = "\A3\Data_F\proxies\weapon_slots\MUZZLE";
                iconPosition[] = {0.05, 0.38};
                iconScale = 0.2;
                class compatibleItems: compatibleItems {
                    muzzle_snds_h_mg_blk_F = 1;
                    muzzle_snds_h_mg_khk_F = 1;
                    muzzle_snds_h_mg = 1;
                };
            };
        };
    };

    class Pistol_Base_F;
    class hgun_ACPC2_F: Pistol_Base_F {
        displayName = CSTRING(ACPC2_Name);
        magazines[] += {"11Rnd_45ACP_Mag"};
        magazineWell[] += {"PistolHeavy_01_45ACP"};
    };
};

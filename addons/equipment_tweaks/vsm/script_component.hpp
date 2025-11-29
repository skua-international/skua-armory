#define SUBCOMPONENT vsm
#define SUBCOMPONENT_BEAUTIFIED VSM
#include "..\script_component.hpp"

#define UNIFORM_ITEM_INFO class ItemInfo: ItemInfo {\
    mass = 40;\
    containerClass = "Supply40";\
}

#define VEST_LITE_ITEM_INFO class ItemInfo: VestItem {\
    mass = 80;\
    containerClass = "Supply140";\
}

#define VEST_OPERATOR_ITEM_INFO class ItemInfo: VestItem {\
    mass = 100;\
    containerClass = "Supply140";\
}

#define VEST_BREACHER_ITEM_INFO class ItemInfo: VestItem {\
    mass = 120;\
    ace_logistics_wirecutter_hasWirecutter = 1;\
    containerClass = "Supply160";\
}

#define VEST_GUNNER_ITEM_INFO class ItemInfo: VestItem {\
    mass = 140;\
    containerClass = "Supply200";\
}

#define CRYE_G3_DISPLAY_NAME(top,bottom) displayName = QUOTE([VSM] Crye G3 (top/bottom))
#define CRYE_G3_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] Crye G3 (camo))
#define CRYE_G3_ROLLED_DISPLAY_NAME(top,bottom) displayName = QUOTE([VSM] Crye G3 RS (top/bottom))
#define CRYE_G3_ROLLED_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] Crye G3 RS (camo))
#define CRYE_G3_POLO_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] Crye G3 Polo (camo))
#define CRYE_G3_TEE_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] Crye G3 Tee (camo))

#define ACU_DISPLAY_NAME(top,bottom) displayName = QUOTE([VSM] Massif ACU (top/bottom))
#define ACU_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] Massif ACU (camo))
#define ACU_ROLLED_DISPLAY_NAME(top,bottom) displayName = QUOTE([VSM] Massif ACU RS (top/bottom))
#define ACU_ROLLED_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] Massif ACU RS (camo))
#define ACU_TEE_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] Massif ACU Tee (camo))

#define BDU_DISPLAY_NAME(top,bottom) displayName = QUOTE([VSM] BDU (top/bottom))
#define BDU_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] BDU (camo))

#define CSAT_DISPLAY_NAME_SINGLE(camo) displayName = QUOTE([VSM] CSAT (camo))

#define VEST_DISPLAY_NAME(name,camo,variant) displayName = QUOTE([VSM] name (camo/variant))
#define VEST_DISPLAY_NAME_NOVARIANT(name,camo) displayName = QUOTE([VSM] name (camo))

#define HEARING_PROTECTION_PELTOR ace_hearing_protection = 0.75;\
    ace_hearing_lowerVolume = 0
#define HEARING_PROTECTION_BOWMAN ace_hearing_protection = 0.45;\
    ace_hearing_lowerVolume = 0

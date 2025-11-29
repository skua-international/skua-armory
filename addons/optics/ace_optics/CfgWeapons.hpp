class CfgWeapons {
    class ItemCore;
    class InventoryOpticsItem_Base_F;

    // HAMR
    class optic_Hamr: ItemCore {
        class ItemInfo: InventoryOpticsItem_Base_F {
            class OpticsModes {
                class Hamr2Scope;
            };
        };
    };

    class ACE_optic_Hamr_2D: optic_Hamr {
        class ItemInfo: ItemInfo {
            class OpticsModes: OpticsModes {
                class Hamr2Scope: Hamr2Scope {
                    opticsZoomMin = 0.0625;
                    opticsZoomMax = 0.0625;
                    opticsZoomInit = 0.0625;
                };
            };
        };
    };

    class optic_MRCO: ItemCore {
        class ItemInfo: InventoryOpticsItem_Base_F {
            class OpticsModes {
                class MRCOscope;
            };
        };
    };

    class ACE_optic_MRCO_2D: optic_MRCO {
        class ItemInfo: ItemInfo {
            class OpticsModes: OpticsModes {
                class MRCOscope: MRCOscope {
                    opticsZoomMin = 0.0625;
                    opticsZoomMax = 0.0625;
                    opticsZoomInit = 0.0625;
                };
            };
        };
    };
};

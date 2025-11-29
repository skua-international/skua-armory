class CfgWeapons {
    class ItemCore;
    class InventoryOpticsItem_Base_F;
    class optic_Hamr: ItemCore {
        class ItemInfo: InventoryOpticsItem_Base_F {
            class OpticsModes {
                class Hamr2Scope {
                    opticsZoomMin = 0.0625;
                    opticsZoomMax = 0.125;
                    opticsZoomInit = 0.125;
                };
            };
        };
    };
    class optic_MRCO: ItemCore {
        class ItemInfo: InventoryOpticsItem_Base_F {
            class OpticsModes {
                class MRCOscope {
                    opticsZoomMin = 0.0625;
                };
            };
        };
    };
};

class CfgWeapons {
    class InventoryItem_Base_F;
    class UniformItem: InventoryItem_Base_F {
        uniformType = "Neopren";
    };
    class ItemCore;
    class Uniform_Base: ItemCore {
        class ItemInfo: UniformItem {
            uniformType = "Neopren";
        };
    };
    class U_BasicBody: Uniform_Base {
        class ItemInfo: UniformItem {
            uniformType = "Neopren";
        };
    };
    class U_BasicBody_Swim: Uniform_Base {
        class ItemInfo: UniformItem {
            uniformType = "Neopren";
        };
    };
};

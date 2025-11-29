class CfgVehicles {
    class CargoNet_01_box_F;
    class APM_large_box: CargoNet_01_box_F {
        maximumLoad = 999999;
        displayName = "[APM] Cargo Net";
        ace_cargo_size = 2;
        ace_cargo_space = 6;
        class TransportItems {};
        class TransportWeapons {};
        class TransportMagazines {};
    };
    class Box_EAF_Wps_F;
    class APM_large_crate: Box_EAF_Wps_F {
        maximumLoad = 999999;
        displayName = "[APM] Storage Box";
        ace_cargo_size = 2;
        ace_cargo_space = 6;
        class TransportItems {};
        class TransportWeapons {};
        class TransportMagazines {};
    };
};

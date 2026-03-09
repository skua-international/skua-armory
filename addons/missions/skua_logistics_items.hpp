class GVAR(logisticsItems) {
    class SpareWheel {
        displayName = "Spare Wheel";
        object = "ACE_Wheel";
        description = "A spare wheel for vehicles.";
        price = 0; // Placeholder, not gonna be set here
    };
    class Track {
        displayName = "Spare Track";
        object = "ACE_Track";
        description = "A spare track for tracked vehicles.";
        price = 0; // Placeholder, not gonna be set here
    };
    /* class FuelCanister {
        displayName = "Fuel Canister";
        object = "Land_CanisterFuel_F";
        description = "An empty fuel canister for refueling vehicles.";
        price = 0; // Placeholder, not gonna be set here
        onPull = QFUNC(logistics_onPullFuelCanister);
    }; */
    class CargoNet {
        displayName = "Cargo Net";
        object = "APM_largeBox";
        description = "A weightless cargo net for packing ACE Cargo.";
        price = 0; // Placeholder, not gonna be set here
    };
    class Crate {
        displayName = "Storage Crate";
        object = "APM_large_crate";
        description = "A weightless crate for storing items.";
        price = 0; // Placeholder, not gonna be set here
    };
    class AmmoBoxMortar82mm {
        displayName = "82mm Ammo Box";
        object = "ACE_Box_82mm_Mo_Combo";
        description = "A box of 82mm mortar ammunition.";
        price = 0; // Placeholder, not gonna be set here
    };
    class AmmoBoxMortar60mm {
        displayName = "60mm Ammo Box";
        object = "Box_60mm_AMMO_F";
        description = "A box of 60mm mortar ammunition.";
        price = 0; // Placeholder, not gonna be set here
    };
    class SparePartsBox {
        displayName = "Spare Parts Box";
        object = "FL_parts_SpareParts";
        description = "A box containing spare parts for vehicle repairs.";
        price = 0; // Placeholder, not gonna be set here
    };
    /* class FleffSparePartsParent {
        displayName = "Repair Parts";
        object = "";
        description = "sub-menu for Fleffs Advanced Repair Major Parts.";
        price = 0; // Placeholder, not gonna be set here
        children = QFUNC(logistics_getMajorParts);
    }; */
    class MedicalBox {
        displayName = "Medical Box";
        object = "ACE_medicalSupplyCrate_advanced";
        description = "A box of medical supplies.";
        price = 0; // Placeholder, not gonna be set here
    };
};

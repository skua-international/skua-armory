class CfgVehicles {
    class CargoNet_01_box_F;
    class APM_large_box: CargoNet_01_box_F { // keep APM_large_box name for backwards compatibility with old missions
        maximumLoad = 1; // enough to hold a notepad
        displayName = "[SKUA] Cargo Net";
        ace_dragging_ignoreWeight = 1;
        ace_dragging_ignoreWeightCarry = 1;

        // 2 cargo spaces, 2 size.
        // essentially a way to compress multiple cargo items into a single item,
        // to simplify loading/unloading/paradropping
        // e.g. you can load 2 spare wheels into this box and then load that box into a vehicle
        ace_dragging_canDrag = 1;
        ace_dragging_canCarry = 1;
        ace_cargo_size = 2;
        ace_cargo_space = 2;
        ace_cargo_canLoad = 1;
        ace_cargo_hasCargo = 1;
        class TransportItems {};
        class TransportWeapons {};
        class TransportMagazines {};
    };

    class Box_EAF_Wps_F;
    class APM_large_crate: Box_EAF_Wps_F { // Keep APM_large_crate name for backwards compatibility with old missions
        // a box of holding, basically. Can hold anything and has no weight.
        // also ignores carry limits, so you can drag it even if it's "too heavy" because of what's inside.
        // the downside is that to move it you have to actually go, unload it from the vehicle, then pick it up.
        maximumLoad = 1e10; // effectively infinite, since the box itself has no weight
        displayName = "[SKUA] Storage Box";
        ace_dragging_ignoreWeight = 1;
        ace_dragging_ignoreWeightCarry = 1;
        ace_cargo_size = 1;
        ace_cargo_space = 0;
        ace_cargo_canLoad = 1;
        ace_cargo_hasCargo = 1;
        class TransportItems {};
        class TransportWeapons {};
        class TransportMagazines {};
    };
};

#include "script_component.hpp"

// TEH's own loot_vehicle addon (addons/loot_vehicle/XEH_postInit.sqf) adds a
// "Pack to the box" ACE self-interaction action on CAManBase (dead bodies)
// that scavenges everything nearby into a box - but the box it creates is a
// bare createVehicle ["VirtualReammoBox_small_F", ...] with no Antistasi
// init at all, unlike every other buyable/utility object (which all go
// through A3A_fnc_initObject, core/functions/UtilityItems/fn_initObject.sqf).
// Confirmed via source: that's why a packed box has none of a real loot
// crate's actions (Carry object, Gather Scattered Loot, etc.) - it was never
// registered as one.
//
// The action's own code is an anonymous block passed straight into
// ace_interact_menu_fnc_createAction, not a named global function, so there
// is nothing to wrap (the pattern this addon's sibling fixes normally use) -
// removing and replacing the whole action is the only option. Deferred one
// frame (CBA_fnc_execNextFrame) purely so this always runs after
// loot_vehicle's own same-frame postInit has already added the original,
// regardless of CBA's postInit dispatch order between addons - removing an
// action that was never added would just be a silent no-op, not an error,
// but the replacement still needs to land after the original either way.
[{
    ["CAManBase", 0, ["ACE_MainActions", "LootVehicleTransferAction"]] call ace_interact_menu_fnc_removeActionFromClass;

    private _unloadToBox = [
        "LootVehicleTransferAction", "Pack to the box", "a3\ui_f\data\IGUI\Cfg\Actions\unloadVehicle_ca.paa",
        {
            params ["_target", "_player"];

            private _pos = getPosATL _target;
            // A3A_faction_reb get "lootCrate" instead of loot_vehicle's own
            // VirtualReammoBox_small_F - the real loot crate class (e.g.
            // A3AP_Box_Syndicate_Ammo_F on TEH), same class a bought one is.
            // A3A_fnc_initObject requires the object's type to already be
            // registered in A3A_utilityItemHM - it is, as long as loot
            // crates are enabled at all (core/functions/init/fn_initUtilityItems.sqf
            // registers it with flags ["move", "place", "loot"], and that
            // "loot" flag is what makes initObject also add the Gather
            // Scattered Loot action) - if a mission has loot crates disabled
            // entirely, initObject logs an error and this box just doesn't
            // get the full treatment, same as a real one couldn't be bought
            // either in that case.
            private _lootCrateType = A3A_faction_reb get "lootCrate";
            private _box = createVehicle [_lootCrateType, [_pos select 0, _pos select 1, (_pos select 2) + 1], [], 0, "CAN_COLLIDE"];
            [_box] call A3A_fnc_initObject;

            systemChat "LootVehicle: Scavenging the surroundings";

            //first dropped weapons, as they are erased with the body otherwise
            private _holders = nearestObjects[_target,["WeaponHolderSimulated"], 5];
            //then everything else
            private _containerList = (nearestObjects[_target,["CAManBase","WeaponHolder"], 3] select {!alive _x || !(_x isKindOf "CAManBase")});
            private _loots = _holders + _containerList;
            private _ignoreIntel = true;
            [_box,_loots,_player, _ignoreIntel] spawn loot_vehicle_fnc_transferToVehicle;
            _player setCaptive false;
        },
        {
            params ["_target", "_player"];
            !alive _target;
        },
        {}
    ] call ace_interact_menu_fnc_createAction;

    ["CAManBase", 0, ["ACE_MainActions"], _unloadToBox, true] call ace_interact_menu_fnc_addActionToClass;
}] call CBA_fnc_execNextFrame;

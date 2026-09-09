#include "script_component.hpp"

// Idempotency guard: field-confirmed (RPT: "Error GIAS pre stack size
// violation" from inside the A3A_fnc_initUtilityItems wrap) that this script
// can run more than once against the same missionNamespace - a dedicated
// server restarting the mission in place without a full process restart is
// the likely trigger, though the exact mechanism wasn't pinned down. Every
// wrap below follows the same capture-then-reassign shape:
// `GVAR(originalX) = X; X = {... _this call GVAR(originalX) ...};` - and
// GVAR(originalX) is a plain mutable missionNamespace global, not a
// snapshotted closure value (an earlier bug in this same file, the
// GVAR(makeCrateLootable) fix, established that a `private` doesn't survive
// into a separately-invoked reassigned global function either, so this
// isn't a case of "just make it private" - see that fix's own history). If
// this script runs a second time, "GVAR(originalX) = X" captures the FIRST
// wrapper (not the true original), then reassigning X to a second wrapper
// still leaves the first wrapper's own body reading the same
// now-overwritten GVAR(originalX) at call time - which by then points back
// at the first wrapper itself, recursing forever. Simplest fix: never let
// the install logic run twice in the first place.
if (!isNil QGVAR(installed)) exitWith {};
GVAR(installed) = true;

// Shared by every crate-like object this addon touches (rebel-buyable loot
// crate, surrender crate, outpost/garrison ammo box, salvage equipment box) -
// carryable and weight-exempt (ace_dragging_fnc_setCarryable, see its own
// call site below for the ignoreWeightCarry reasoning), and ACE
// cargo-loadable into other vehicles at a fixed, small footprint
// (ace_cargo_fnc_setSize 1) while not itself accepting cargo
// (ace_cargo_fnc_setSpace 0 - these are boxes to carry, not vehicles that
// hold other cargo). Both cargo functions are "global effect... adds the
// [...] action menu if necessary" per their own docs
// (ace3/docs/wiki/framework/cargo-framework.md) - same self-contained,
// call-and-done shape as setCarryable, nothing else needed.
GVAR(makeCrateLootable) = {
    params ["_object"];
    [_object, true, nil, nil, true, true] call ace_dragging_fnc_setCarryable;
    [_object, 1] call ace_cargo_fnc_setSize;
    [_object, 0] call ace_cargo_fnc_setSpace;
};

// Make loot crates (and anything else Antistasi itself flags the same way)
// ACE-carryable, on any variant that has them at all. Wraps
// A3A_fnc_initObject rather than config-patching a specific loot crate
// class directly (e.g. ace_dragging_canCarry = 1 on
// A3AP_Box_Syndicate_Ammo_F, which ACE's own init EH would also pick up
// automatically) - that classname happens to be identical on Ultimate/TEH,
// but hardcoding it per-variant isn't necessary when initObject itself
// already has the real signal to key off: A3A_utilityItemHM's own
// per-type "loot" flag (fn_initObject.sqf reads the same flag itself, to
// decide whether to add the Gather Scattered Loot action - reusing exactly
// that instead of re-deriving "is this a loot crate" a second, narrower way
// via A3A_faction_reb get "lootCrate"). CE has no loot-flagged entries in
// A3A_utilityItemHM at all (confirmed via source - no "lootCrate" faction
// key, nothing to flag), so this wrap is a permanent no-op there. Default
// carry position/direction (ACE's own [0,1,1]/0) are fine as-is - not
// overridden.
if (!isNil "A3A_fnc_initObject") then {
    GVAR(originalInitObject) = A3A_fnc_initObject;
    A3A_fnc_initObject = {
        params [["_object", objNull, [objNull]]];
        private _result = _this call GVAR(originalInitObject);

        private _entry = if (isNil "A3A_utilityItemHM") then {[]} else {A3A_utilityItemHM getOrDefault [typeOf _object, []]};
        private _flags = _entry param [4, []];
        if ("loot" in _flags) then {
            // Arg 4 (ignoreWeightCarry) - confirmed via fnc_startCarryLocal.sqf:
            // when set, the object's own weight (ace_dragging_fnc_getWeight,
            // includes its cargo) is skipped entirely rather than checked
            // against ACE_maxWeightCarry, so a full loot crate is never
            // refused for being too heavy to pick up.
            [_object] call GVAR(makeCrateLootable);
        };

        // Medical tent: add a scroll-wheel action to buy a medical supply
        // crate on the spot, via A3A_fnc_buyItem - the exact same function
        // the shop UI's own buy button calls (confirmed via source,
        // gui/functions/GUI/fn_buyVehicleTabs.sqf), so cost, purchase
        // cooldown, commander-only gating and placement behavior are
        // identical to buying it normally, not reimplemented here. Saves a
        // trip back to a trader to resupply a tent that's already placed.
        private _medTentType = if (isNil "A3A_faction_reb") then {""} else {A3A_faction_reb getOrDefault ["vehicleHealthStation", ""]};
        if (_medTentType != "" && {typeOf _object isEqualTo _medTentType}) then {
            private _medBoxType = (A3A_faction_reb getOrDefault ["vehicleMedicalBox", ["", 0]]) select 0;
            if (_medBoxType != "") then {
                _object addAction [
                    format ["Buy %1", getText (configFile >> "CfgVehicles" >> _medBoxType >> "displayName")],
                    {
                        params ["", "", "", "_medBoxType"];
                        [player, _medBoxType] call A3A_fnc_buyItem;
                    },
                    _medBoxType,
                    1.5, false, true, "",
                    "alive _target"
                ];
            };
        };

        _result
    };
};

// Surrender crates (fn_surrenderAction.sqf), outpost/base "zone ammo boxes"
// (fn_createZoneAmmoBox.sqf), and salvage-mission equipment boxes
// (fn_LOG_Salvage.sqf) get the same carryable/weightless/cargo-loadable
// treatment (GVAR(makeCrateLootable), above), and are also wired into the
// garage system's own "void the crate, transfer contents to arsenal" path
// (garage/Public/fn_addVehicle.sqf's
// _utilityRefund - triggers when A3A_canGarage is set AND the object's type
// is registered in A3A_utilityItemHM with the "loot" flag; currently neither
// is true for either kind of crate).
//
// Both fall outside the initObject wrap above: confirmed via source, neither
// fn_surrenderAction.sqf nor fn_createZoneAmmoBox.sqf ever calls
// A3A_fnc_initObject, and their classnames aren't fixed like the loot crate
// either - fn_surrenderAction.sqf resolves Faction(side) get "surrenderCrate"
// per the surrendering unit's own side (or A3A_faction_riv directly for
// rivals), fn_createZoneAmmoBox.sqf resolves Faction(side) get "ammobox" per
// the captured zone's side - varying per faction/mission config (e.g.
// Box_IND_Wps_F, Box_East_Wps_F, rhs_7ya37_1_single across different faction
// templates, confirmed via source), not one fixed class to config-patch or
// type-match against.
//
// Resolved dynamically instead, straight from the same faction hashmaps
// those functions themselves read (Faction(SIDE) macro expansion,
// core/Includes/common.inc: west -> A3A_faction_occ, east -> A3A_faction_inv,
// opfor -> A3A_faction_riv). A3A_faction_reb (resistance/rebel) is also
// checked, for CE specifically - confirmed via source that CE's own
// fn_surrenderAction.sqf resolves the surrender crate from
// FactionGet(reb, "surrenderCrate") (its own single fixed class), not
// per-enemy-side like Ultimate/TEH - a real per-variant divergence in where
// the classname lives, not just which function creates the object.
// Confirmed CE's own outpost loot crates (fn_garrisonLocal_spawn.sqf ->
// A3A_fnc_setupLootCrate.sqf, CE's equivalent of fn_createZoneAmmoBox.sqf)
// resolve "ammobox" the same per-side way Ultimate/TEH do, so no CE-specific
// handling was needed for that key.
//
// Done inside this same A3A_fnc_initObject wrap's sibling,
// A3A_fnc_initUtilityItems - not at raw postInit - because that function's
// own docstring requires it be called "after faction loading", and it's the
// only hook already guaranteed to run at the right time server-side (it's
// where A3A_utilityItemHM itself gets built, so this is also the one place
// it's safe to add entries to it). Class registration only needs to happen
// once, server-side - the CBA "Init" event handler then covers every future
// spawn of these classes regardless of which function creates it, and
// ace_dragging_fnc_setCarryable's own global flag (arg 5) syncs the carry
// state to clients from there, same as the loot crate fix above already
// relies on.
if (!isNil "A3A_fnc_initUtilityItems") then {
    GVAR(originalInitUtilityItems) = A3A_fnc_initUtilityItems;
    A3A_fnc_initUtilityItems = {
        _this call GVAR(originalInitUtilityItems);

        if (isServer) then {
            // A3A_faction_reb included for CE's sake specifically - confirmed
            // via source that CE's own fn_surrenderAction.sqf resolves the
            // surrender crate from FactionGet(reb, "surrenderCrate") (the
            // REBEL faction's own single fixed class, e.g. Box_IND_Wps_F),
            // not per-enemy-side like Ultimate/TEH's fn_surrenderAction.sqf
            // (Faction(_unitSide) get "surrenderCrate", or A3A_faction_riv
            // for rivals) - a genuine per-variant divergence, not just a
            // difference in which function creates the crate. Harmless for
            // the "ammobox" key on any variant - confirmed CE's own
            // RebelDefaults.sqf has no "ammobox" entry, so this is a no-op
            // there for that key.
            private _fnc_resolveClassnames = {
                params ["_key"];
                private _classnames = [];
                {
                    private _faction = missionNamespace getVariable [_x, createHashMap];
                    private _class = _faction getOrDefault [_key, ""];
                    if (_class != "") then {_classnames pushBackUnique _class};
                } forEach ["A3A_faction_occ", "A3A_faction_inv", "A3A_faction_riv", "A3A_faction_reb"];
                _classnames
            };

            // equipmentBox: the crate spawned for the sunken-ship "Logistics
            // for Salvage" mission (core/functions/Missions/fn_LOG_Salvage.sqf,
            // Faction(side) get "equipmentBox" - same per-side shape and
            // resolution as "ammobox", confirmed via source on both CE and
            // Ultimate/TEH).
            private _classnames = (["surrenderCrate"] call _fnc_resolveClassnames) + (["ammobox"] call _fnc_resolveClassnames) + (["equipmentBox"] call _fnc_resolveClassnames);

            {
                if !(_x in A3A_utilityItemHM) then {
                    A3A_utilityItemHM set [_x, [_x, -1, "", "", ["move", "loot"]]];
                };

                [_x, "init", {
                    params ["_object"];
                    _object setVariable ["A3A_canGarage", true, true];
                    [_object] call GVAR(makeCrateLootable);
                }, true, [], true] call CBA_fnc_addClassEventHandler;
            } forEach _classnames;

            // Medical tents (bought/placed via the utility item shop,
            // FactionGet(reb, "vehicleHealthStation")) don't persist across
            // a mission restart, unlike objects placed through the building
            // placer - confirmed via source, fn_saveLoop.sqf's save
            // collection only includes utility items whose own
            // A3A_utilityItemHM flags contain "save"
            // (`"save" in ((A3A_utilityItemHM get typeOf _x) select 4)`),
            // and the tent's own registration
            // (["place", "move", "rotate", "pack"]) never had it. Appending
            // to the existing entry's flags rather than replacing it, so
            // its other behavior (placeable, movable, rotatable, packable)
            // is untouched.
            private _medTentType = A3A_faction_reb getOrDefault ["vehicleHealthStation", ""];
            if (_medTentType != "") then {
                private _entry = A3A_utilityItemHM getOrDefault [_medTentType, []];
                if (_entry isNotEqualTo [] && {!("save" in (_entry select 4))}) then {
                    private _updated = +_entry;
                    _updated set [4, (_entry select 4) + ["save"]];
                    A3A_utilityItemHM set [_medTentType, _updated];
                };
            };
        };
    };
};

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
// TEH-only in practice (loot_vehicle isn't present on CE or regular
// Ultimate, confirmed via source) - guarded at runtime rather than via
// requiredAddons/skipWhenMissingDependencies, since this whole addon's other
// fix (loot crate carrying, above) applies on every variant and shouldn't be
// gated behind a TEH-only dependency.
//
// The action's own code is an anonymous block passed straight into
// ace_interact_menu_fnc_createAction, not a named global function, so there
// is nothing to wrap (the pattern the fix above uses) - removing and
// replacing the whole action is the only option. Deferred one frame
// (CBA_fnc_execNextFrame) purely so this always runs after loot_vehicle's
// own same-frame postInit has already added the original, regardless of
// CBA's postInit dispatch order between addons - removing an action that
// was never added would just be a silent no-op, not an error, but the
// replacement still needs to land after the original either way.
[{
    if (isNil "loot_vehicle_fnc_transferToVehicle") exitWith {};

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

// Combat Outpost: an aggressive variant of the commander's Watchpost action -
// adds "Combat Outpost" to the outpost-type dropdown, and behaves identically
// to a Watchpost (same cost formula, no extra tier gate, same marker type)
// except its AI garrison patrols COMBAT/RED instead of STEALTH/GREEN.
// Ultimate-only: gated on the presence of Ultimate's own outpost functions
// rather than requiredAddons, the same runtime-guard shape as the TEH
// loot_vehicle fix above - CE and TEH have no watchpost concept at all, so
// there's nothing to hook there.
//
// Design: rather than reimplementing the whole watchpost pipeline (save/load,
// garrison eligibility, distance-based spawn/despawn, frontline calc, etc.)
// as an independent emplacement type, a Combat Outpost IS a Watchpost as far
// as Antistasi's own bookkeeping is concerned - it lives in the same
// watchpostsFIA array, uses the same marker type/class, and goes through the
// same SCRT_fnc_outpost_createWatchpost call. "COMBATPOST" only exists as
// this addon's own UI-facing outpostType value; it's disguised as
// "WATCHPOST" before handing off to Antistasi's own cost calc and
// establishment flow, and the real distinguishing bit (aggressive) is
// tracked as a broadcast missionNamespace variable keyed by marker name (see
// GVAR(fnc_setAggressiveOutpost)/GVAR(fnc_isAggressiveOutpost) below - a
// marker is a plain string, not a valid setVariable/getVariable target)
// applied after Antistasi's own creation call succeeds.
//
// SCRT_fnc_outpost_createWatchpostDistance is the one piece that can't be
// wrapped call-through style: it sets the garrison's behaviour/combat mode
// once, immediately, then blocks in a waitUntil for the emplacement's entire
// lifetime (which can be the rest of the mission) before returning - by the
// time a wrap's "after call-through" code would run, the post is long gone.
// That one function is vendored wholesale below (copied from Ultimate's own
// core/functions/Outpost/fn_outpost_createWatchpostDistance.sqf) with only
// the behaviour/combat-mode branch changed to check the aggressive flag.
//
// Antistasi's own save/load does NOT preserve arbitrary marker setVariables
// for watchposts - fn_saveLoop.sqf's watchpostsFIA case only round-trips
// [position, garrison] per entry, and fn_loadStat.sqf's "watchpostsFIA" case
// recreates each marker fresh (fixed type/color, no variables restored).
// So this addon separately persists a parallel array of aggressive-flags
// (same order as watchpostsFIA, since nothing reorders that array between
// the vanilla save/load pass and this addon's own pass) under its own save
// key, and reapplies it right after Antistasi's own load finishes.
if (!isNil "SCRT_fnc_outpost_createWatchpost") then {
    // Markers are plain strings, not one of setVariable/getVariable's valid
    // target types (Namespace/Object/Group/Display/Control/Team
    // member/Task/Location) - confirmed the hard way (RPT: "Error
    // getvariable: Type String, expected Namespace,Object,..."). Antistasi's
    // own code never calls setVariable ON a marker either - see e.g.
    // fn_outpost_createWatchpost.sqf's own `spawner setVariable [_marker,
    // 2, true]`, which sets a variable ON THE spawner object, keyed BY the
    // marker name string. Same shape here, keyed on missionNamespace (any
    // real Namespace/Object works as the target; nothing else in this addon
    // needs that particular value namespaced further) with the marker name
    // folded into the variable name itself so different markers don't
    // collide. The isGlobal broadcast on the setter matches what a direct
    // `_marker setVariable [..., true]` would have done had it worked.
    GVAR(fnc_isAggressiveOutpost) = {
        missionNamespace getVariable [format [QGVAR(outpostAggressive) + "_%1", _this], false]
    };
    GVAR(fnc_setAggressiveOutpost) = {
        params ["_marker", "_value"];
        missionNamespace setVariable [format [QGVAR(outpostAggressive) + "_%1", _marker], _value, true];
    };

    GVAR(originalPopulateCommanderMenu) = SCRT_fnc_ui_populateCommanderMenu;
    SCRT_fnc_ui_populateCommanderMenu = {
        private _result = _this call GVAR(originalPopulateCommanderMenu);
        private _idx = lbAdd [2750, "Combat Outpost"];
        lbSetData [2750, _idx, "COMBATPOST"];
        _result
    };

    // Cost is identical to WATCHPOST's own formula, so rather than
    // duplicating it we briefly disguise the combobox selection as
    // WATCHPOST for the duration of the original cost calc (which reads it
    // straight back out of the listbox), then restore both the listbox data
    // and the outpostType global it sets as a side effect.
    GVAR(originalSetOutpostCost) = SCRT_fnc_ui_setOutpostCost;
    SCRT_fnc_ui_setOutpostCost = {
        disableSerialization;
        private _display = findDisplay 60000;
        private _isCombatPost = false;
        private _index = -1;
        if (!isNull _display) then {
            _index = lbCurSel (_display displayCtrl 2750);
            if (_index >= 0 && {lbData [2750, _index] == "COMBATPOST"}) then {
                _isCombatPost = true;
                lbSetData [2750, _index, "WATCHPOST"];
            };
        };

        private _result = _this call GVAR(originalSetOutpostCost);

        if (_isCombatPost) then {
            lbSetData [2750, _index, "COMBATPOST"];
            outpostType = "COMBATPOST";
        };

        _result
    };

    // Disguise as WATCHPOST before the original resource/task/radio checks
    // and tier gate run (WATCHPOST has no tier gate, matching "combat posts
    // work the same as regular watchposts"), and remember that this
    // establishment is meant to end up aggressive so the createWatchpost
    // wrap below can tag the resulting marker.
    GVAR(originalSetEstablishOutpostMode) = SCRT_fnc_ui_setEstablishOutpostMode;
    SCRT_fnc_ui_setEstablishOutpostMode = {
        GVAR(pendingAggressiveOutpost) = (outpostType == "COMBATPOST");
        if (GVAR(pendingAggressiveOutpost)) then {outpostType = "WATCHPOST"};
        _this call GVAR(originalSetEstablishOutpostMode);
    };

    // Tag the newly-created marker aggressive once Antistasi's own
    // (long-running, server-only) establishment call actually succeeds -
    // detected by diffing watchpostsFIA before/after, since the original
    // never returns or exposes the marker it creates.
    GVAR(originalCreateWatchpost) = SCRT_fnc_outpost_createWatchpost;
    SCRT_fnc_outpost_createWatchpost = {
        if (!isServer) exitWith {_this call GVAR(originalCreateWatchpost)};

        private _aggressive = GVAR(pendingAggressiveOutpost);
        GVAR(pendingAggressiveOutpost) = false;
        private _before = +watchpostsFIA;

        private _result = _this call GVAR(originalCreateWatchpost);

        if (_aggressive) then {
            {
                [_x, true] call GVAR(fnc_setAggressiveOutpost);
                [_x] remoteExec ["A3A_fnc_mrkUpdate", 0, true];
            } forEach (watchpostsFIA - _before);
        };

        _result
    };

    // Color-only marker differentiation, per explicit simplification - no
    // new marker class/icon/title, just override the existing watchpost
    // marker's color when it's flagged aggressive. Runs after call-through
    // since A3A_fnc_mrkUpdate recomputes (and would otherwise reset) marker
    // color on every invocation, not just at creation - see its own
    // colorTeamPlayer branch. Mirrors that function's own "Dum"-prefix
    // dummy-marker resolution so the override lands on whichever marker is
    // actually visible.
    GVAR(originalMrkUpdate) = A3A_fnc_mrkUpdate;
    A3A_fnc_mrkUpdate = {
        params [["_markerName", "", [""]]];
        private _result = _this call GVAR(originalMrkUpdate);

        private _originalName = if (_markerName find "Dum" == 0) then {
            _markerName select [3, (count _markerName) - 3]
        } else {
            _markerName
        };

        if (_originalName call GVAR(fnc_isAggressiveOutpost)) then {
            private _dummyName = format ["Dum%1", _originalName];
            private _visibleMarkerName = [_originalName, _dummyName] select (markerShape _dummyName != "");
            _visibleMarkerName setMarkerColorLocal "ColorRed";
        };

        _result
    };

    // Vendored copy of Ultimate's core/functions/Outpost/fn_outpost_createWatchpostDistance.sqf -
    // see the block comment above for why this one can't be a call-through
    // wrap. Only change from the original: behaviour/combat mode branches on
    // A3A_outpostAggressive instead of being unconditionally STEALTH/GREEN.
    SCRT_fnc_outpost_createWatchpostDistance = {
        params ["_markerX"];

        if (!isServer and hasInterface) exitWith {};

        private _positionX = getMarkerPos _markerX;
        private _typeGroup = A3A_faction_reb get "groupSniper";
        private _aggressive = _markerX call GVAR(fnc_isAggressiveOutpost);

        private _props = [];

        private _groupX = [_positionX, teamPlayer, _typeGroup] call A3A_fnc_spawnGroup;
        if (_aggressive) then {
            _groupX setBehaviour "COMBAT";
            _groupX setCombatMode "RED";
        } else {
            _groupX setBehaviour "STEALTH";
            _groupX setCombatMode "GREEN";
        };
        {
            [_x, _markerX] spawn A3A_fnc_FIAinitBases;
        } forEach units _groupX;

        private _campfire = createVehicle ["Land_Campfire_F", _positionX];
        private _tent = ["Land_TentDome_F", getPosWorld _campfire] call BIS_fnc_createSimpleObject;
        _tent setDir (random 360);
        _tent setPos [(getPos _tent select 0) + 4, (getPos _tent select 1) + 4, (getPos _tent select 2) - 0.2];

        _props pushBack _campfire;
        _props pushBack _tent;

        {
            _x setVectorUp surfaceNormal position _x;
        } forEach _props;

        [_markerX, "RebelWatchpost", true] call A3A_events_fnc_triggerEvent;

        waitUntil {
            sleep 1;
            ((spawner getVariable _markerX == 2)) or
            ({alive _x} count units _groupX == 0) or (!(_markerX in watchpostsFIA))
        };

        if ({alive _x} count units _groupX == 0) then {
            watchpostsFIA = watchpostsFIA - [_markerX]; publicVariable "watchpostsFIA";
            markersX = markersX - [_markerX]; publicVariable "markersX";
            sidesX setVariable [_markerX, nil, true];
            [5, -5, _positionX] remoteExec ["A3A_fnc_citySupportChange", 2];
            deleteMarker _markerX;
            ["TaskFailed", ["", (localize "STR_notifiers_watchpost_lost")]] remoteExec ["BIS_fnc_showNotification", 0];
        };

        waitUntil {sleep 1; (spawner getVariable _markerX == 2) or (!(_markerX in watchpostsFIA))};

        {
            deleteVehicle _x
        } forEach units _groupX;
        deleteGroup _groupX;

        {
            deleteVehicle _x;
        } forEach _props;

        [_markerX, "RebelWatchpost", false] call A3A_events_fnc_triggerEvent;
    };

    // Persist the aggressive flags (see block comment above for why this is
    // needed at all) alongside Antistasi's own save, under this addon's own
    // key so it doesn't collide with anything vanilla save/load whitelists.
    if (!isNil "A3A_fnc_saveLoop") then {
        GVAR(originalSaveLoop) = A3A_fnc_saveLoop;
        A3A_fnc_saveLoop = {
            private _result = _this call GVAR(originalSaveLoop);
            private _flags = watchpostsFIA apply {_x call GVAR(fnc_isAggressiveOutpost)};
            [QGVAR(aggressiveOutpostFlags), _flags] call A3A_fnc_setStatVariable;
            _result
        };
    };

    if (!isNil "A3A_fnc_loadServer") then {
        GVAR(originalLoadServer) = A3A_fnc_loadServer;
        A3A_fnc_loadServer = {
            private _result = _this call GVAR(originalLoadServer);

            private _flags = [QGVAR(aggressiveOutpostFlags)] call A3A_fnc_returnSavedStat;
            if (!isNil "_flags" && {count _flags == count watchpostsFIA}) then {
                {
                    if (_x) then {
                        [(watchpostsFIA select _forEachIndex), true] call GVAR(fnc_setAggressiveOutpost);
                    };
                } forEach _flags;

                if (watchpostsFIA findIf {_x call GVAR(fnc_isAggressiveOutpost)} != -1) then {
                    [watchpostsFIA] remoteExec ["A3U_fnc_mrkUpdateBulk", 0, true];
                };
            };

            _result
        };
    };
};

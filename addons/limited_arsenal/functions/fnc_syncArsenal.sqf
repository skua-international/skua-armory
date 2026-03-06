#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Sync an ACE Arsenal to an object's inventory.
 * The Arsenal's virtual (unlimited) items will be kept as-is, with the object's inventory items added on top, with limited quantity.
 * Changes to the arsenal's virtual inventory after sync will not be tracked. This is a one-time sync, not a persistent link.
 * An arsenal can only be synced once. Syncing an already synced arsenal will do nothing.
 * The inventory however can be synced to multiple arsenals, to allow multiple arsenals pulling from the same inventory.
 *
 * Arguments:
 * 0: The Arsenal object that will be opened. This is the box you ACE Interact on. Can be the Base Arsenal from skua_missions or any other box.
 * 1: The object whose inventory will be synced to the Arsenal. This is usually a box, but can be anything with an inventory. Can be the same as the arsenal itself.
 *
 * Return Value:
 * <NONE>
 *
 * Example:
 * [myArsenal, myBox] call skua_limited_arsenal_fnc_syncArsenal;
 *
 * Public: No
 */

params ["_box", "_inventory"];
TRACE_1("fnc_syncArsenal",_this);

private _synced = _box getVariable [QGVAR(synced), []];
if (_synced isEqualTo []) then {
    GVAR(boxes) set [_box, nil]; // Need to keep track
    // Get the box's virtual inventory.
    private _virtual = _box call ACEFUNC(arsenal,getVirtualItems);

    // Might change, so persist now
    _box setVariable [QGVAR(virtual), _virtual];

    // Set the array reference
    _box setVariable [QGVAR(synced), _synced];
};

_synced pushBack _inventory;

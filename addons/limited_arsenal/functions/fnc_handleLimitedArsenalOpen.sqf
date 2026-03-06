#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Handle opening a limited arsenal. Add the synced inventory to the arsenal's virtual inventory and start the sync PFH.
 * Assumes only once arsenal can be opened per client. Which is correct anyway, you only have one UI.
 *
 * Arguments:
 * 0: The arsenal being opened.
 *
 * Return Value:
 *  <NONE>
 *
 * Example:
 * [openedArsenal] call skua_limited_arsenal_fnc_handleLimitedArsenalOpen;
 *
 * Public: No
 */

params ["_box"];
TRACE_1("fnc_handleLimitedArsenalOpen",_this);

private _inventory = _box getVariable [QGVAR(synced), objNull];

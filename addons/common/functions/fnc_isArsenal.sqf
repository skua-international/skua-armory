#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Check if an object is an arsenal.
 *
 * Arguments:
 * 0: Object to check <OBJECT>
 *
 * Return Value:
 * Is Arsenal <BOOL>
 *
 * Example:
 * cursorObject call skua_common_fnc_isArsenal;
 *
 * Public: No
 */
params ["_box"];
TRACE_1("fnc_isArsenal",_this);

_box in GVAR(allArsenals) // return

#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Opens the Base Arsenal. The Base Arsenal is accessible while inside an Arsenal Area,
 * and is shared between all Arsenal Areas on the map.
 *
 * Arguments:
 * 0: The unit to open the base arsenal for <OBJECT>
 *
 * Return Value:
 * <NONE>
 *
 * Example:
 * call skua_missions_fnc_openBaseArsenal;
 *
 * Public: No
 */
params ["_unit"];

[GVAR(baseArsenal), _unit, false] call ACEFUNC(arsenal,openBox);

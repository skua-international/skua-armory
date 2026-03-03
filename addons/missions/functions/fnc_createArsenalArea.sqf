#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Create an Arsenal Area.
 *
 * Arguments:
 * 0: The side that can access this arsenal area. If not specified, all sides can access it. <SIDE> (default: sideUnknown)
 * 1: Area center - see inArea syntax 2 for details <OBJECT or POSITION or GROUP>
 * 2: X axis radius <SCALAR>
 * 3: Y axis radius <SCALAR>
 * 4: Rectangle or ellipse <BOOL> - if false, the area will be an ellipse. If true, the area will be a rectangle aligned to the sides of the map.
 * 5: Z axis radius, the height <SCALAR> (default: -1)
 *
 * Return Value:
 * <NONE>
 *
 * Example:
 * [sideWest, player, 10, 10, false] call skua_missions_fnc_createArsenalArea;
 *
 * Public: No
 */

params ["_side", "_center", "_xRadius", "_yRadius", "_isRectangle", "_zRadius"];
TRACE_1("fnc_createArsenalArea",_this);

private _locationArray = [_center, _xRadius, _yRadius, 0, _isRectangle, _zRadius];
if (_side == sideUnknown) then {
    // Add to everything
    {
        _x pushBack _locationArray;
    } forEach (values GVAR(arsenalAreas));
} else {
    // Add to specified side
    (GVAR(arsenalAreas) get _side) pushBack _locationArray;
};

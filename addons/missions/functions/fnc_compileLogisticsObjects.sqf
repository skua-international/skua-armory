#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Compile Logistics Objects from Config.
 *
 * Arguments:
 * None.
 *
 * Return Value:
 * Array of logistics actions objects.
 *
 * Example:
 * call skua_missions_fnc_compileLogisticsObjects;
 *
 * Public: No
 */

TRACE_1("fnc_compileLogisticsObjects","");

private _cfg = configFile >> QGVAR(logisticsItems);

private _objects = [];
{
    private _class = configName _x;
    private _object = getText (_x >> "object");
    private _displayName = getText (_x >> "displayName");
    private _children = getText (_x >> "children");
    private _onPull = getText (_x >> "onPull");

    _objects pushBack [
        _class,
        _object,
        _displayName,
        _children,
        _onPull
    ];
} forEach ("true" configClasses _cfg);

_objects // return

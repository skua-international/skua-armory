#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Add logistics action menu to an object.
 *
 * Arguments:
 * 0: Object to add actions to <OBJECT>
 *
 * Return Value:
 * None. <NONE>
 *
 * Example:
 * [object] call skua_missions_fnc_logistics_addDispenserActions;
 *
 * Public: No
 */

#define INTERACTION_DISTANCE 8

params ["_dispenser"];
TRACE_1("fnc_logistics_addDispenserActions",_this);

private _logisticsMenu = [
    QGVAR(logisticsMenu), // menu action name
    "Logistics", // Display name
    "a3\ui_f_oldman\data\igui\cfg\holdactions\repair_ca.paa", // Icon
    {}, // Statement
    {true}, // Condition
    nil, // children
    nil, // Arguments
    nil, // Position
    INTERACTION_DISTANCE
] call ACEFUNC(interact_menu,createAction);

[_dispenser, 0, ["ACE_MainActions"],  _logisticsMenu] call ACEFUNC(interact_menu,addActionToObject);

private _fnc_makeObjectAction = {
    params ["_class", "_objectClassname", "_displayName", "_children", "_onPull", ["_subMenu", ""]];

    private _action = [
        format [QGVAR(logisticsMenu_%1), _class],
        _displayName,
        "",
        {
            params ["_target", "_player", "_arguments"];
            (_arguments) params ["_objectClassname", "_onPull"];

            // Create
            private _object = createVehicle [_objectClassname, [0, 0, 0], [], 0, "NONE"];
            _object setPosASL (_player modelToWorldWorld [0, 1, 0]);

            // Make carryable and draggable with no weight
            [_object, true, nil, nil, true, true] call ACEFUNC(dragging,setCarryable);
            [_object, true, nil, nil, true, true] call ACEFUNC(dragging,setDraggable);

            // Custom onPull behavior if defined
            if (_onPull isNotEqualTo "") then {
                _object call (missionNamespace getVariable [_onPull, {}]);
            };

            // Make player carry it
            [ACE_player, _object] call ACEFUNC(dragging,startCarry);
        },
        {true},
        nil,
        [_objectClassname, _onPull],
        nil,
        INTERACTION_DISTANCE
    ] call ACEFUNC(interact_menu,createAction);

    private _path = ["ACE_MainActions", QGVAR(logisticsMenu)];
    if (_subMenu isNotEqualTo "") then {
        _path pushBack _subMenu;
    };

    [_dispenser, 0, _path, _action] call ACEFUNC(interact_menu,addActionToObject);
};

private _fnc_makeSubMenu = {
    params ["_class", "", "_displayName", "_children", "_onPull"];

    private _menuClass = format [QGVAR(logisticsMenu_%1), _class];

    private _menuAction = [
        _menuClass,
        format ["Grab %1", _displayName],
        "a3\ui_f_oldman\data\igui\cfg\holdactions\repair_ca.paa",
        {},
        {true},
        nil,
        nil,
        nil,
        INTERACTION_DISTANCE
    ] call ACEFUNC(interact_menu,createAction);

    [_dispenser, 0, ["ACE_MainActions", QGVAR(logisticsMenu)], _menuAction] call ACEFUNC(interact_menu,addActionToObject);

    private _children = call (missionNamespace getVariable [_children, {[]}]);
    {
        [
            format ["%1_%2", _menuClass, _forEachIndex], 
            _x, 
            getText (configFile >> "CfgVehicles" >> _x >> "displayName"), 
            "", 
            _onPull,
            _menuClass
        ] call _fnc_makeObjectAction;
    } forEach _children;
};

private _logiObjects = call FUNC(logistics_getObjects);
{
    _x params ["", "", "", "_children", ""];
    if (_children isNotEqualTo "") then {
        _x call _fnc_makeSubMenu;
    } else {
        _x call _fnc_makeObjectAction;
    };
} forEach _logiObjects;

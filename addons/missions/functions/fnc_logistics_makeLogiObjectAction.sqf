#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Make the ACE Interaction Menu Action for a Logistics Object.
 *
 * Arguments:
 * 0: LogiObject class name (not the same as the classname of the object to be created) <STRING>
 * 1: Object classname to create when action is pulled <STRING>
 * 2: Display name for the action <STRING>
 * 3: Array of objects that are children of this action in the menu. Values are classnames. (optional, default: empty array) <ARRAY of STRING>
 * 4: Function to call when the action is pulled (optional, default: none) <STRING>
 *
 * Return Value:
 * ACE Interaction Menu Action <ARRAY>
 *
 * Example:
 * [params] call skua_missions_fnc_logistics_makeLogiObjectAction
 *
 * Public: No
 */

// Irrelevant for self-interaction, but used for distance checks when adding the action to objects
#define INTERACTION_DISTANCE 8

params ["_class", "_objectClassname", "_displayName", "_children", "_onPull"];
TRACE_1("fnc_logistics_makeLogiObjectAction",_this);

private _statement = if (_children isEqualTo "") then {
    {
        params ["_target", "_player", "_arguments"];
        (_arguments) params ["_objectClassname", "_onPull"];

        // Create
        private _object = createVehicle [_objectClassname, [0, 0, 0], [], 0, "NONE"];
        _object hideObjectGlobal true;
        _object setPosASL (_player modelToWorldWorld [0, 1, 0]);

        // Make carryable and draggable with no weight
        [_object, true, nil, nil, true, true] call ACEFUNC(dragging,setCarryable);
        [_object, true, nil, nil, true, true] call ACEFUNC(dragging,setDraggable);

        // Custom onPull behavior if defined
        if (_onPull isNotEqualTo "") then {
            _object call (missionNamespace getVariable [_onPull, {}]);
        };

        // Make player carry it
        [_player, _object] call ACEFUNC(dragging,startCarry);
        _object hideObjectGlobal false;
    } // statement
} else {
    {} // empty statement with children
};

private _childActions = if (_children isEqualTo []) then {
    {} // no children
} else {
    private _childClasses = call (missionNamespace getVariable [_children, {[]}]);
    private _childActionArray = _childClasses apply {
        [
            format [QGVAR(logisticsMenu_%1_%2), _class, _x],
            _x,
            getText (configFile >> "CfgVehicles" >> _x >> "displayName"),
            "",
            _onPull
        ] call FUNC(logistics_makeLogiObjectAction)
    };
    _childActionArray = _childActionArray apply {[_x, [], _target]};

    private _strArray = str _childActionArray;
    compile _strArray // return array of child actions
};

[
    format [QGVAR(logisticsMenu_%1), _class], // menu action name
    _displayName, // Display name
    "", // Icon (optional, default: none)
    _statement, // Statement
    {true},
    _childActions, // children
    [_objectClassname, _onPull], // Arguments to pass to statement
    nil,
    INTERACTION_DISTANCE
] call ACEFUNC(interact_menu,createAction);

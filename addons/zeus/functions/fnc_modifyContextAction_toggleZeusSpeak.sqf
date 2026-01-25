#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Modify the Toggle Zeus Context Menu Action to set the title accordingly.
 *
 * Arguments:
 * 0: Action Data <ARRAY>
 *
 * Return Value:
 * Return description <NONE>
 *
 * Example:
 * call skua_zeus_fnc_modifyContextAction_toggleZeusSpeak
 *
 * Public: No
 */
TRACE_1("fnc_modifyContextAction_toggleZeusSpeak",_this);

params ["_actionData"];

// Defer to the action modifier, as they share the same logic
[nil, nil, nil, _actionData] call FUNC(modifyAction_toggleZeusSpeak);

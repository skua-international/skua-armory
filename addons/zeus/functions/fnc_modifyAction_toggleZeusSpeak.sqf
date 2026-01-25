#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Modify the Toggle Zeus Action to set the title accordingly.
 *
 * Arguments:
 * 0-2: Unused <ANY>
 * 3: Action arguments <ARRAY>
 *
 * Return Value:
 * Return description <NONE>
 *
 * Example:
 * call skua_zeus_fnc_modifyAction_toggleZeusSpeak
 *
 * Public: No
 */
TRACE_1("fnc_modifyAction_toggleZeusSpeak",_this);

params ["", "", "", "_actionData"];

private _title = ["Speak through Camera", "Speak through Player"] select GVAR(speakingThroughZeus);

_actionData set [1, _title];

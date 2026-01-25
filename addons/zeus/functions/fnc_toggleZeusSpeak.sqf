#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Hack: Toggle ACRE2 speaking through Zeus Camera.
 *
 * Arguments:
 * 0: Argument (optional, default: value) <OBJECT>
 *
 * Return Value:
 * Return description <NONE>
 *
 * Example:
 * call skua_zeus_fnc_toggleZeusSpeak
 *
 * Public: No
 */

TRACE_1("fnc_toggleZeusSpeak",_this);

if (GVAR(speakingThroughZeus)) exitWith {
    GVAR(speakingThroughZeus) = false;
    GVAR(toggleHintCtrlGroup) ctrlShow false;
    GVAR(toggleHintCtrlGroup) ctrlEnable false;
    GVAR(toggleHintCtrlGroup) = nil;
    call acre_sys_zeus_fnc_handleZeusSpeakPressUp;
};

GVAR(speakingThroughZeus) = true;

private _control = ["You are speaking through Zeus Camera.", "ACE Interact > Speak through Player to stop.", 1e10] call BIS_fnc_curatorHint;

GVAR(toggleHintCtrlGroup) = ctrlParentControlsGroup _control;

call acre_sys_zeus_fnc_handleZeusSpeakPress;

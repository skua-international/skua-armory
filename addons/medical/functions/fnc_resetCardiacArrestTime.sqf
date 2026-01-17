#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Reset the cardiac arrest timer for a unit
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorObject] call skua_medical_fnc_resetCardiacArrestTime;
 *
 * Public: No
 */

params ["_unit"];

private _timeLeftVar = QACEGVAR(medical_statemachine,cardiacArrestTimeLeft);

if (_unit isNil _timeLeftVar) exitWith {};

private _timeLeft = _unit getVariable QACEGVAR(medical_statemachine,cardiacArrestTimeLeft);

private _newTime = _timeLeft + ACEGVAR(medical_statemachine,cardiacArrestTime);

_unit setVariable [_timeLeftVar, _newTime];

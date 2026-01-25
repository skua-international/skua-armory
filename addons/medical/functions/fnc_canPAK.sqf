#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Check if the patient can be treated with a PAK.
 * Unit must be in stable condition and have no fractures.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * BOOLEAN
 *
 * Example:
 * [cursorObject] call skua_medical_fnc_canPAK;
 *
 * Public: No
 */

params ["_patient"];

private _stable = _patient call ACEFUNC(medical_status,isInStableCondition);

if (!_stable) exitWith { false };

private _fractures = GET_FRACTURES(_patient);

_fractures isEqualTo [] // return

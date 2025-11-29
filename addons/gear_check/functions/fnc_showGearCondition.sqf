#include "..\script_component.hpp"

params ["_unit", "_checkBasic", "_checkSpecial"];

private _missingGear = [];
if (_checkBasic) then {
    _missingGear append ([_unit] call FUNC(getMissingGear));
};
if (_checkSpecial) then {
    _missingGear append ([_unit] call FUNC(getSpecialGear));
};

_missingGear isNotEqualTo []

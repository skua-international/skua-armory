#include "script_component.hpp"

[QACEGVAR(arsenal,displayOpened), {
    if !(ACEGVAR(arsenal,currentBox) in GVAR(boxes)) exitWith {};

    ACEGVAR(arsenal,currentBox) call FUNC(handleLimitedArsenalOpen);
}] call CBA_fnc_addEventHandler;

[QACEGVAR(arsenal,displayClosed), {

}] call CBA_fnc_addEventHandler;

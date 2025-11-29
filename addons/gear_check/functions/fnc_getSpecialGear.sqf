#include "..\script_component.hpp"


params ["_unit"];

// NON-FUNCTIONAL

private _roles = [_unit] call FUNC(findRoles);
if (_roles isEqualTo []) exitWith {[]};

private _unitItems = uniqueUnitItems [_unit, 0, 2, 2, 2, true];

private _missing = [];

{
    switch (toLower _x) do {
        case "medic": {
            [["ACE_bodyBag_blue"], _unitItems,      3, "Bodybags (Blue)", _missing] call FUNC(countItem);
            [["ACE_bodyBag_white"], _unitItems,     2, "Bodybags (White)", _missing] call FUNC(countItem);
            [["ACE_adenosine"], _unitItems,         2, "Adenosine", _missing] call FUNC(countItem);
            [["ACE_epinephrine"], _unitItems,       2, "Epinephrine", _missing] call FUNC(countItem);
            [["ACE_morphine"], _unitItems,          2, "Morphine", _missing] call FUNC(countItem);
            [["ACE_elasticBandage"], _unitItems,    30, "Bandages (Elastic)", _missing] call FUNC(countItem);
            [["ACE_packingBandage"], _unitItems,    20, "Bandages (Packing)", _missing] call FUNC(countItem);
            [["ACE_quikclot"], _unitItems,          20, "Bandages (Quikclot)", _missing] call FUNC(countItem);
            [["ACE_suture"], _unitItems,            40, "Sutures", _missing] call FUNC(countItem);
            [["ACE_salineIV"], _unitItems,          3, "Saline IV (1000ml)", _missing] call FUNC(countItem);
            [["ACE_salineIV_500"], _unitItems,      6, "Saline IV (500ml)", _missing] call FUNC(countItem);
            [["ACE_salineIV_250"], _unitItems,      4, "Saline IV (250ml)", _missing] call FUNC(countItem);
            [["ACE_splint"], _unitItems,            5, "Splints", _missing] call FUNC(countItem);
            [["ACE_tourniquet"], _unitItems,        8, "Tourniquets", _missing] call FUNC(countItem);
            [["ACE_surgicalKit"], _unitItems,       1, "Surgical Kit", _missing] call FUNC(countItem);
            // [["kat_chestSeal"], _unitItems,         2, "Chest Seals", _missing] call FUNC(countItem);
            // [["kat_guedel"], _unitItems,            6, "Guedel Tubes", _missing] call FUNC(countItem);
            // [["kat_larynx"], _unitItems,            2, "KingLT", _missing] call FUNC(countItem);
            // [["kat_Pulseoximeter"], _unitItems,     2, "Pulse Oximeter", _missing] call FUNC(countItem);
            // [["kat_stethoscope"], _unitItems,       1, "Stethoscope", _missing] call FUNC(countItem);
        };
        case "engineer": {
            [["ACE_wirecutter"], _unitItems,        1, "Wirecutter", _missing] call FUNC(countItem);
            [["ACE_EntrenchingTool"], _unitItems,   1, "Entrenching Tool", _missing] call FUNC(countItem);
            [["ToolKit"], _unitItems,               1, "Toolkit", _missing] call FUNC(countItem);
            [["DemoCharge_Remote_Mag"], _unitItems, 2, "M112 Demo Block", _missing] call FUNC(countItem);
            [["ACE_rope3","ACE_rope6"], _unitItems, 2, "Rope", _missing] call FUNC(countItem);
        };
        case "eod": {
            [["ACE_Clacker", "ACE_M26_Clacker"], _unitItems,    1, "Clacker", _missing] call FUNC(countItem);
            [["ACE_DefusalKit"], _unitItems,                    1, "Defusal Kit", _missing] call FUNC(countItem);
            [["ACE_wirecutter"], _unitItems,                    1, "Wirecutter", _missing] call FUNC(countItem);
            [["DemoCharge_Remote_Mag"], _unitItems,             2, "M112 Demo Block", _missing] call FUNC(countItem);
            [["ace_marker_flags_green"], _unitItems,            5, "Marker Flag (Green)", _missing]  call FUNC(countItem);
            [["ace_marker_flags_red"], _unitItems,              5, "Marker Flag (Red)", _missing]   call FUNC(countItem);

            if !(handgunWeapon _unit in ["ACE_VMH3", "ACE_VMM3"]) then {
                _missing pushBackUnique "Mine Detector";
            };
        };
        case "signaller": {
            [["ACE_Chemlight_HiRed"], _unitItems,      3, "Chemlight (Hi Red)", _missing] call FUNC(countItem);
            [["ACE_Chemlight_HiGreen"], _unitItems,    3, "Chemlight (Hi Green)", _missing] call FUNC(countItem);
            [["ACE_Chemlight_HiYellow"], _unitItems,   6, "Chemlight (Hi Yellow)", _missing] call FUNC(countItem);
            [["ACE_HandFlare_Green"], _unitItems,      2, "Hand Flare (Green)", _missing] call FUNC(countItem);
            [["ACE_HandFlare_Red"], _unitItems,        2, "Hand Flare (Red)", _missing] call FUNC(countItem);
            [["ACE_HandFlare_Yellow"], _unitItems,     4, "Hand Flare (Yellow)", _missing] call FUNC(countItem);
            [["SmokeShellOrange"], _unitItems,         2, "Smoke Shell (Orange)", _missing] call FUNC(countItem);
        };
        case "ol";
        case "el";
        case "ftl": {
            [["ACRE_PRC152", "ACRE_PRC117F"], _unitItems, 1, "AN/PRC-152", _missing] call FUNC(countItem);
        };
        case "sl": {
            [["ACRE_PRC152", "ACRE_PRC117F"], _unitItems, 2, "AN/PRC-152", _missing] call FUNC(countItem);
        };
        default { };
    };
} forEach _roles;

if (_missing isNotEqualTo []) then {
    _missing insert [0, ["Missing Special Gear:"]];
};

_missing

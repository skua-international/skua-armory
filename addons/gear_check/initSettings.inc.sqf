[
    QGVAR(enabled),
    "CHECKBOX",
    "Require Equipment",
    ["Skua Mods", "Arsenal - Gear Check"],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requirePrimary),
    "CHECKBOX",
    "Primary Weapon",
    ["Skua Mods", "Arsenal - Gear Check"],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requirePrimaryAmmo),
    "SLIDER",
    "Primary Ammunition",
    ["Skua Mods", "Arsenal - Gear Check"],
    [0, 300, 120, 0, false],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(requireHandgun),
    "CHECKBOX",
    "Handgun Weapon",
    ["Skua Mods", "Arsenal - Gear Check"],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(requireHandgunAmmo),
    "SLIDER",
    "Handgun Ammunition",
    ["Skua Mods", "Arsenal - Gear Check"],
    [0, 150, 0, 0, false],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(requireVest),
    "CHECKBOX",
    "Vest",
    ["Skua Mods", "Arsenal - Gear Check"],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requireNVG),
    "CHECKBOX",
    "NVG",
    ["Skua Mods", "Arsenal - Gear Check"],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(requireRadio),
    "CHECKBOX",
    "Radio",
    ["Skua Mods", "Arsenal - Gear Check"],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requireShovel),
    "CHECKBOX",
    "Entrenching Tool",
    ["Skua Mods", "Arsenal - Gear Check"],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requireEarplugs),
    "CHECKBOX",
    "Ear Plugs",
    ["Skua Mods", "Arsenal - Gear Check"],
    true
] call CBA_fnc_addSetting;

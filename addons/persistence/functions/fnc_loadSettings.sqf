#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Load persistence settings from CBA settings into their proper holder variables.
 *
 * Arguments:
 * None.
 *
 * Return Value:
 * None.
 *
 * Example:
 * call skua_persistence_fnc_loadSettings;
 *
 * Public: No
 */

GVAR(enabled) = GVAR(enabled_setting);
GVAR(key) = format ["%1_%2", GVAR(key_setting), GVAR(environment_setting)];
GVAR(location) = GVAR(location_setting);
GVAR(saveLoadouts) = GVAR(saveLoadouts_setting);
GVAR(savePosition) = GVAR(savePosition_setting);
GVAR(saveMedical) = GVAR(saveMedical_setting);
GVAR(ephemeralDataTimeout) = GVAR(ephemeralDataTimeout_setting);

GVAR(settingsLoaded) = true;

INFO_2("Persistence settings loaded. Key: %1, Location: %2",GVAR(key),GVAR(location));

TRACE_1("Running queued functions after settings loaded: %1 items",count GVAR(runAfterSettingsLoaded));
{
    _x params ["_func", "_args"];
    _args call _func;
} forEach GVAR(runAfterSettingsLoaded);

GVAR(runAfterSettingsLoaded) = nil;

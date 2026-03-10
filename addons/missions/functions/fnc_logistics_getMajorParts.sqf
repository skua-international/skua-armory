#include "..\script_component.hpp"
/*
 * Authors: LinkIsGrim
 * Get major parts for Advanced Repair.
 *
 * Arguments:
 * None.
 *
 * Return Value:
 * Array of part classnames.
 *
 * Example:
 * call skua_missions_fnc_logistics_getMajorParts;
 *
 * Public: No
 */

TRACE_1("fnc_logistics_getMajorParts","");

[
    "FL_parts_rotorassembly",
    "FL_parts_engineturbinesmall",
    "FL_parts_engineturbinelarge",
    "FL_parts_controlsurfaces",
    "FL_parts_avionics",
    "FL_parts_enginepistonlarge",
    "FL_parts_enginepistonmedium",
    "FL_parts_enginepistonsmall",
    "FL_parts_gunfcs",
    "FL_parts_turretdrive",
    "FL_parts_fueltanksmall",
    "FL_parts_fueltanklarge"
] // return

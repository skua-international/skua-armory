#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Create a UUIDv7, as string.
 *
 * Return Value:
 * UUIDv7 <STRING>
 *
 * Example:
 * call skua_common_fnc_createUUIDv7;
 *
 * Public: No
 */

("skua" callExtension ["uuid", []]) params ["_uuid"];

_uuid // return

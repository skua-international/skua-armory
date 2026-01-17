#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Save a vehicle's fuel to a holder hashmap
 *
 * Arguments:
 * 0: Vehicle to save <OBJECT>
 * 1: Holder hashmap <HASHMAP>
 *
 * Return Value:
 * None, hashmap is modified.
 *
 * Example:
 * [cursorObject, create] call skua_persistence_fnc_saveVehicle_fuel;
 *
 * Public: No
 */
params ["_vehicle", "_holder"];

private _fuel = _vehicle call ACEFUNC(refuel,getFuel);

_holder set [HASHKEY_VEHICLE_FUEL, _fuel toFixed 3]; // fuel is in litres, 3 decimal points means we get up to mL precision

nil // return

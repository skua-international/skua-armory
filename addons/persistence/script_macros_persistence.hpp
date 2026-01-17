// Object (generic) keys
// Objects are any entities in the mission: vehicles, static objects, units, etc.

// Classname is saved as the case-sensitive classname of the object
#define HASHKEY_OBJECT_CLASSNAME QUOTE(object_classname)

// UUID is a UUIDv7
#define HASHKEY_OBJECT_UUID QUOTE(object_uuid)

// Position is saved as ATL position
#define HASHKEY_OBJECT_POSITION QUOTE(object_position)

// Determines that the object was seen at this map
// Relevancy: we save medical information, we don't want a player to potentially:
// - disconnect from an operation
// - switch to the training server
// - get a full heal
// - reconnect to the operation
//
// It's an annoying case, but still one we should handle.
// It's also relevant for position. We don't want the player to teleport by moving in another terrain when loading back in.
#define HASHKEY_OBJECT_WORLDNAME QUOTE(object_last_world)

// Units (children of CAManBase) keys
// Units are infantry entities

// Loadout is saved as the CBA Extended Loadout: includes earplugs, second primary weapons, etc.
#define HASHKEY_UNIT_LOADOUT QUOTE(unit_loadout)
// Medical state is saved as the output of ace_medical_fnc_serializeState
#define HASHKEY_UNIT_MEDICAL QUOTE(unit_medical_state)

// Vehicle keys
// Should be obvious

// Fuel is saved as the output of ace_refuel_fnc_getFuel
// And restored with ace_refuel_fnc_setFuel
#define HASHKEY_VEHICLE_FUEL QUOTE(vehicle_fuel)

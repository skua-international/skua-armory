// Object (generic) keys
// Objects are any entities in the mission: vehicles, static objects, units, etc.

// Kind is saved as one of:
// - "Unit" for infantry entities (children of CAManBase)
// - "Player" for player-controlled infantry entities
// - "Container" for containers (objects that can hold items, e.g., crates, backpacks, etc.)
// - "Vehicle" for vehicles (children of LandVehicle, Air, Ship, etc.)
// - "Static" for static objects (everything else)
#define HASHKEY_OBJECT_KIND QUOTE(kind)

// Name is a vanity name assigned to the object
// Could be the player's name for units, a renamed cargo container, etc.
#define HASHKEY_OBJECT_NAME QUOTE(name)

// Classname is saved as the case-sensitive classname of the object
#define HASHKEY_OBJECT_CLASSNAME QUOTE(classname)

// UUID is a UUIDv7
#define HASHKEY_OBJECT_UUID QUOTE(uuid)

// Position is saved as ATL position
#define HASHKEY_OBJECT_POSITION QUOTE(position)

// Orientation is the object's vectorDirAndUp
#define HASHKEY_OBJECT_ORIENTATION QUOTE(orientation)

// Direction is the object's heading in degrees (0-360)
#define HASHKEY_OBJECT_DIRECTION QUOTE(direction)

// Determines that the object was seen at this map
// Relevancy: we save medical information, we don't want a player to potentially:
// - disconnect from an operation
// - switch to the training server
// - get a full heal
// - reconnect to the operation
//
// It's an annoying case, but still one we should handle.
// It's also relevant for position. We don't want the player to teleport by moving in another terrain when loading back in.
#define HASHKEY_OBJECT_WORLDNAME QUOTE(last_world)

// Units (children of CAManBase) keys
// Units are infantry entities

// Loadout is saved as the CBA Extended Loadout: includes earplugs, second primary weapons, etc.
#define HASHKEY_UNIT_LOADOUT QUOTE(loadout)
// Medical state is saved as the output of ace_medical_fnc_serializeState
#define HASHKEY_UNIT_MEDICAL QUOTE(medical_state)

#define HASHKEY_PLAYER_STEAM_ID QUOTE(steam_id)
#define HASHKEY_PLAYER_RANK QUOTE(rank)
#define HASHKEY_PLAYER_ADMINSTATUS QUOTE(admin_status)
#define HASHKEY_PLAYER_CERTIFICATIONS QUOTE(certifications)

// Vehicle keys
// Should be obvious

// Fuel is saved as the output of ace_refuel_fnc_getFuel
// And restored with ace_refuel_fnc_setFuel
#define HASHKEY_VEHICLE_FUEL QUOTE(fuel)

#define PERSISTENCE_LOCATION_LOCAL 0
#define PERSISTENCE_LOCATION_REMOTE 1

#define DATABASESTATE_AWAITCONNECT 0
#define DATABASESTATE_CONNECTED_INIT 1
#define DATABASESTATE_CONNECTED_AWAIT_INIT 2
#define DATABASESTATE_FAILED 3

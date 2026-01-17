#include "script_component.hpp"

if (isServer) then {
    GVAR(admins) = getArray (configFile >> "enableDebugConsole");
    if (!isMultiplayer) then {
        // In singleplayer, the only player is an admin
        GVAR(admins) pushBack getPlayerUID player;
    };

    [QACEGVAR(zeus,createZeus), {
        params ["_unit"];
        if (getPlayerUID _unit in GVAR(admins)) exitWith {}; // Admins doing this is fine

        // Others are not; send them to the shadow realm

        endMission "UnauthorizedZeus";
    }] call CBA_fnc_addEventHandler;

    [QEGVAR(common,clientConnected), {
        params ["_uid", "_hasInterface", "_playerObject"];

        INFO_3("Client with ID %1 and Object %2 connected. Headless: %3",_uid,_playerObject,!_hasInterface);
    }] call CBA_fnc_addEventHandler;

    [QEGVAR(common,clientConnected), LINKFUNC(createAdminZeus)] call CBA_fnc_addEventHandler;

    GVAR(serverAddons) = cba_common_addons;

    // Map structure: UID (STRING) -> ARRAY of ARRAY of STRING: [extraAddons, missingAddons]
    GVAR(clientAddonMap) = createHashMap;

    // Addon monitoring
    [QGVAR(addons), LINKFUNC(onClientAddons)] call CBA_fnc_addEventHandler;
    [QGVAR(requestClientAddons), LINKFUNC(handleRequestClientAddons)] call CBA_fnc_addEventHandler;

    addMissionEventHandler ["PlayerDisconnected", {
        params ["", "_uid"];
        GVAR(clientAddonMap) deleteAt _uid;
    }];
};

call FUNC(sendClientAddons);

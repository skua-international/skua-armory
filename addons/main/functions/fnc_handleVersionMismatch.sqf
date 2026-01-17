#include "..\script_component.hpp"
/*
 * Author: LinkIsGrim
 * Handle version mismatch by displaying a warning to the player
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_serverVersion", "_localVersion"];

private _fnc_determineClientHigher = {
    private _clientIsHigher = false;
    {
        private _serverNum = _x;
        private _clientNum = _localVersion select _forEachIndex;
        _clientIsHigher = _clientNum > _serverNum;
        if (_clientIsHigher) then {
            break;
        }
    } forEach _serverVersion;

    _clientIsHigher // return
};

private _fix = [
    "Please update your mod by repairing it in the Arma 3 Launcher.",
    "Contact a server administrator and request the server be updated;"
] select (call _fnc_determineClientHigher);

private _errorMessage = format [
    [
        "Version Mismatch Detected for the Skua Armory mod.",
        "Local Version is %1, Server Version is %2.",
        "",
        _fix
    ] joinString "<br/>",
    _localVersion joinString ".", _serverVersion joinString "."
];

if (isFilePatchingEnabled) then {
    [{
        private _filePatchingMessage = "You have file patching enabled so this won't kick you, but your mod is mismatched. Fix it if this is a live environment. Original message below.";
        _filePatchingMessage = [_filePatchingMessage, _this] joinString "<br/>";
        _filePatchingMessage = _filePatchingMessage regexReplace ["<br/>", "\n"];
        // Lasts for ~10 seconds
        ERROR_WITH_TITLE("Unit Mod Version Mismatch",_filePatchingMessage);
    }, _errorMessage, 1] call CBA_fnc_waitAndExecute;    
} else {
    ["[SKUA] ERROR: Unit Mod Version Mismatch", _errorMessage] call ACEFUNC(common,errorMessage);
};

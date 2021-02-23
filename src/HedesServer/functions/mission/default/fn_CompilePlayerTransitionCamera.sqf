/*
Configures, compiles, remoteExecs the cinamatic camera transitions for players starting a mission.
The possible camera types are:
1. deploycam
2. missionStartcam
Refer to the configuration for mission types.
*/

private _missiontype = param[0, "default"];
private _cameratype = param[1, "deploycam"];
private _target = param[2, clientowner];

// Lookup Camera Args and execute Command
private _cameraargsname = format["%1args", _cameratype];
private _camerafncname = format["%1fnc", _cameratype];
private _camargs = [configFile >> "CfgHedesMissions" >> _missiontype, _cameraargsname] call HEDESServer_fnc_GetMissionArgProperties;
private _camfnc = gettext(configFile >> "CfgHedesMissions" >> _missiontype >> _camerafncname);

// execute Camera Function on Remote Machines
call compile (format["%1 remoteExec ['%2', %3]", _camargs, _camfnc, _target]);
HEDESServer_fnc_CompilePlayerTransitionCamera = {
	private _missiontype = param[0,"default"];
	private _cameratype = param[1,"deploycam"]; // deploycam or missionstartcam
	private _cameraargsname = format["%1args",_cameratype];
	private _camerafncname = format["%1fnc",_cameratype];
	private _camargs = (getArray(configfile >> "CfgHedesMissions" >> _missiontype >> _cameraargsname)) 
		apply {getText(configfile >> "CfgHedesMissions" >> _missiontype >> _x)};
	private _camfnc = getText(configfile >> "CfgHedesMissions" >> _missiontype >> _camerafncname);
	call compile (format["%1 remoteExec ['%2',0]",_camargs, _camfnc]);
};

HEDESServer_fnc_DefaultGroupMissionManager = {
	private _player = param[0,player];
	private _missiontype = param[1,"default"];

	private _deployobjtype = getText(configfile >> "CfgHedesMissions" >> _missiontype >> "missiondeployobjtype");
	private _deployobj = nearestObject [_player, _deployobjtype];

	// Create Mission Task And Wait For Team To Be Ready
	private _missionTask = format["%1_beginmissiontask", netid _player];
	[group _player, [_missionTask], ["Move all players in squad to marker to begin mission.", "Begin Mission", "cookiemarker"], (getPos _deployobj) ,1, 2, true] call BIS_fnc_taskCreate;
	while{count (units (group _player) select {_x distance (getPos _deployobj) > 10}) > 0} do {sleep 1};
	[_missionTask] call BIS_fnc_deleteTask;	


	[] spawn {["default","deploycam"] call HEDESServer_fnc_CompilePlayerTransitionCamera;
	sleep 2;
	["default","missionstartcam"] call HEDESServer_fnc_CompilePlayerTransitionCamera;}
};
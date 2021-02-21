HEDESServer_fnc_GetMissionArgProperties = {
	private _cfgpath = param[0,configfile >> "CfgHedesMissions" >> "default"];
	private _argsname = param[1,"deploycamargs"];
	(getArray(_cfgpath >> _argsname)) 
		apply {getText(_cfgpath >> _x)}
};

HEDESServer_fnc_CompilePlayerTransitionCamera = {
	private _missiontype = param[0,"default"];
	private _cameratype = param[1,"deploycam"]; // deploycam or missionstartcam
	private _target = param[2,clientOwner];

	// Lookup Camera Args And Execute Command
	private _cameraargsname = format["%1args",_cameratype];
	private _camerafncname = format["%1fnc",_cameratype];
	private _camargs = [configfile >> "CfgHedesMissions" >> _missiontype, _cameraargsname] 
		call HEDESServer_fnc_GetMissionArgProperties;
	private _camfnc = getText(configfile >> "CfgHedesMissions" >> _missiontype >> _camerafncname);
	call compile (format["%1 remoteExec ['%2',%3]",_camargs, _camfnc, _target]);
};

HEDESServer_fnc_DefaultGroupMissionManager = {
	private _player = param[0,player];
	private _missiontype = param[1,"default"];

	// Get Mission Config Variables
	private _deployobjtype = getText(configfile >> "CfgHedesMissions" >> _missiontype >> "missiondeployobjtype");
	private _deployobj = nearestObject [_player, _deployobjtype];

	// Create Mission Task And Wait For Team To Be Ready
	private _missionTask = format["%1_beginmissiontask", netid _player];
	[group _player, [_missionTask], ["Move all players in squad to marker to begin mission.", "Begin Mission", "cookiemarker"], (getPos _deployobj) ,1, 2, true] 
		call BIS_fnc_taskCreate;
	while{count (units (group _player) select {_x distance (getPos _deployobj) > 10}) > 0} do {sleep 1};
	[_missionTask] call BIS_fnc_deleteTask;	

	// Camera Transition Out
	["default","deploycam"] call HEDESServer_fnc_CompilePlayerTransitionCamera;
	sleep 2;

	// Move Group To 
	private _ingresspos = [0,0,0];
	private _missionaoargs = [configfile >> "CfgHedesMissions" >> _missiontype,"missiongtargetareaargs"] call HEDESServer_fnc_GetMissionArgProperties; 
	{
		_ingresspos = call compile format["%2 call %1","HEDESServer_fnc_GetLocationPosByName",_missionaoargs];
		_ingresspos = selectRandom(selectBestPlaces [_ingresspos, 50, "sea - waterDepth + (waterDepth factor [0.05, 0.5])", 1, 5]) select 0; //change me to mission config
		_x setPos _ingresspos;
		// Camera Transition In
		["default","missionstartcam", owner _x] call HEDESServer_fnc_CompilePlayerTransitionCamera;
	} foreach (units(group _player));
};

HEDESServer_fnc_GetLocationPosByName = {
	private _locname = param[0,'Ile Sainte-Marie'];
	private _loctype = param[1,'nameLocal'];
	private _reference = param[2, [worldsize/2,worldsize/2,0]];
	position ((nearestLocations [_reference, [_loctype], worldsize /2]) select {text _x == _locname} select 0);
};
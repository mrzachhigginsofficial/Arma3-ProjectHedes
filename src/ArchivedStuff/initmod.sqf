HEDES_INF_AI_GROUPS = [grpNull];
HEDES_VEH_AI_GROUPS = [grpNull];
HEDES_INPROGRESS_MISSIONS = [];

SPAWNNEWMISSION =  {
	private _playergrp = param[0];
	private _missiontype = param[1];
	private _timelimit = param[2,240];
	private _loadupobj = param[3,player];
	private _mission = nil;

	private _missionTask = format["%1_beginmissiontask", netid _loadupobj];
	[group player, [_missionTask], ["Move all players in squad to marker to begin mission.", "Begin Mission", "cookiemarker"], (getPos _loadupobj) ,1, 2, true] call BIS_fnc_taskCreate;
	while{count (units (group player) select {_x distance (getPos _loadupobj) > 10}) > 0} do {sleep 1};
	[_missionTask] call BIS_fnc_deleteTask;

	switch (_missiontype) do {
		case "DEFEND": {
				_mission = selectrandom HEDES_ATTACKCOMPOSITIONS;
				[_playergrp, _mission, selectRandom [east, independent], _timelimit] spawn doSPAWNDEFENDERMANAGER;
			};
	};
};

doSPAWNDEFENDERMANAGER = {
	private _playergrp = param[0,nil];
	private _mission = param[1,nil];
	private _enemy = param[2,east];
	private _timeleft = param[3,240];
	private _maxinfgrp = param[4,2];
	private _maxvehgrp = param[5,1];
	private _i = 0;

	private _objective = _mission select 0;
	private _compositions = _mission select 1;
	private _returnpos = position (leader _playergrp);

	private _artythread = [_objective] spawn doSPAWNFAKEARTY;
	private _compositions = [_compositions] call SPAWNCOMP;
	private _grps = [];
	private _grpsveh = [];
	private _newveharr = [];
	private _vehsarr = [];

	["Mission starting in %1 seconds.",5,[0]] spawn COUNTDOWNANYTHING;
	sleep 5;
	
	{ [] remoteExec ["CAMERAMISSIONSTART",0] } foreach (units _playergrp);
	sleep 4;
	{ _x setPos (_mission select 0); [] remoteExec ["CAMERACUT1",0]; } foreach (units _playergrp);

	sleep 5;
	["Time Left: %1 seconds",_timeleft,[0]] spawn COUNTDOWNANYTHING;

	while {_timeleft > 0} do
	{
		// SPAWN INFANTRY
		while{ count(_grps select {(count units _x) > 0}) < _maxinfgrp} do {
			_grps append [([_objective, _enemy] call SPAWNATTACKER)];
			_grps append [([_objective, _enemy] call SPAWNATTACKER)];
		};

		// SPAWN VEHICLE
		while{ count(_grpsveh select {(count units _x) > 0}) < _maxvehgrp} do {
			_newveharr = [_objective, _enemy] call SPAWNATTACKERVEH;
			_grpsveh append [(group (driver (_newveharr select 0)))];
			_vehsarr append [(_newveharr select 0)];
		};

		if (COUNT (allUnits select {(_x distance _objective) > 10} apply {side _x} select {_x != (side _playergrp)}) == 0) then 
		{
			_timeleft = _timeleft - 1;	
		};

		sleep 1;
	};

	format["Mission Over! Returning to base."] remoteExec ["hintSilent", 0];
	sleep 10;

	{ _x setPos _returnpos } foreach (units _playergrp);
	{[_x] call DELETEALLATTACKERS} foreach _grps;
	{[_x] call DELETEALLATTACKERS} foreach _grpsveh;
	{deleteVehicle _x} foreach _compositions;
	{deleteVehicle _x} foreach _vehsarr;
	terminate _artythread;
};

doSPAWNFAKEARTY = {
	private _position = param[0];
	private _shellType = ["Sh_82mm_AMOS"];
	private _hitposition = [];
	private _posToFireAt = [];
	private _shell = "";

	while {1==1} do { 
		_hitposition = [[[_position, 300]],[[_position, 150]]] call BIS_fnc_randomPos;		
		_posToFireAt = [_hitposition, (random 150), (random 360)] call BIS_fnc_relPos;
		_posToFireAt set [2, 800]; 
		_shell = (selectRandom _shellType) createVehicle _posToFireAt; 
		_shell setPos _posToFireAt; 
		_shell setVelocity [0,0,-200]; 
		sleep (random 30);
	};
};

DELETEALLATTACKERS = {
	private _grp = param[0];
	{deleteVehicle _x} foreach (units _grp);
};

SPAWNATTACKER = {
	private _position = param[0,nil];
	private _side = param[1,nil];
	private _number = param[2,5];
	private _spawnpos = 
		[[[_position, 150]],[[_position, 100],["water"]]] call BIS_fnc_randomPos;
	private _grp = [_spawnpos, _side, _number] call BIS_fnc_spawnGroup;
	{_x allowfleeing 0} foreach (units _grp);
	[_grp, _position] call BIS_fnc_taskAttack;	
	_grp
};

SPAWNATTACKERVEH = {
	private _position = param[0,nil];
	private _side = param[1,nil];
	private _type = param[2,'Car'];
	private _sideNum = 4;

	switch(_side)do
	{
		case east: {_sideNum = 0};
		case west: {_sideNum = 1};
		case resistance: {_sideNum = 2};
	};

	private _spawnpos = 
		[[[_position, 350]],[[_position, 400],["water"]]] call BIS_fnc_randomPos;
	_spawnpos = [_spawnpos, 500] call BIS_fnc_nearestRoad;
	private _name = selectRandom((
		"(getText (_x >> 'vehicleClass') in [_type]) && 
		(getNumber (_x >> 'side') == _sideNum) && 
		(getNumber (_x >> 'transportSoldier') > 2)" 
		configClasses (configFile >> "CfgVehicles")) apply {configName _x});
	private _veh = [getPos _spawnpos, random 360, _name, _side] call BIS_fnc_spawnVehicle;
	private _grp = group (driver (_veh select 0));
	{_x allowfleeing 0} foreach (units _grp);
	[_veh select 0, _grp] call BIS_fnc_spawnCrew;
	[_grp, _position] call BIS_fnc_taskAttack;
	_veh;
};

COUNTDOWNANYTHING = {
	private _message = param[0,""];
	private _timespan = param[1,60];
	private _playertargets = param[2,[]];

	while {0 < _timespan} do {
		{[format[_message, _timespan]] remoteExec ["hintSilent", _x]} forEach _playertargets;
		_timespan = _timespan - 1;
		sleep 1;
	};
};
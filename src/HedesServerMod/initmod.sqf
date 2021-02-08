HEDES_INF_AI_GROUPS = [grpNull];
HEDES_VEH_AI_GROUPS = [grpNull];


SPAWNATTACKERMANAGER = {
	private _objective = param[0,nil];
	private _enemy = param[1,east];
	private _timeleft = param[2,240];
	private _i = 0;

	[_objective] call SPAWNFAKEARTY;

	while{_timeleft > 0}do
	{
		format["Time Left: %1 seconds", _timeleft] remoteExec ["hintSilent", 0];

		// SPAWN INFANTRY
		{_i = _i + (count(units _x))} foreach HEDES_INF_AI_GROUPS;
		if (_i == 0) then {
			HEDES_INF_AI_GROUPS = [grpNull];
			HEDES_INF_AI_GROUPS append [([_objective, _enemy] call SPAWNATTACKER)];
			HEDES_INF_AI_GROUPS append [([_objective, _enemy] call SPAWNATTACKER)];
		};

		// SPAWN VEHICLE
		{_i = _i + (count(units _x))} foreach HEDES_VEH_AI_GROUPS;
		if (_i == 0) then {
			HEDES_VEH_AI_GROUPS = [grpNull];
			HEDES_VEH_AI_GROUPS append [group (driver (([_objective, _enemy] call SPAWNATTACKERVEH) select 0))];
		};

		_timeleft = _timeleft - 1;
		sleep 1;
	};
};

SPAWNATTACKER = {
	private _objective = param[0,nil];
	private _side = param[1,nil];
	private _number = param[2,5];
	private _spawnpos = 
		[[[position _objective, 150]],[[position _objective, 100],["water"]]] call BIS_fnc_randomPos;
	private _group = [_spawnpos, _side, _number] call BIS_fnc_spawnGroup;
	[_group, getpos _objective] call BIS_fnc_taskAttack;	
	_group
};

SPAWNATTACKERVEH = {
	private _objective = param[0,nil];
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
		[[[position _objective, 200]],[[position _objective, 150],["water"]]] call BIS_fnc_randomPos;
	_spawnpos = [_spawnpos, 500] call BIS_fnc_nearestRoad;
	private _name = selectRandom((
		"(getText (_x >> 'vehicleClass') in [_type]) && 
		(getNumber (_x >> 'side') == _sideNum) && 
		(getNumber (_x >> 'transportSoldier') > 2)" 
		configClasses (configFile >> "CfgVehicles")) apply {configName _x});
	private _veh = [getPos _spawnpos, random 360, _name, _side] call BIS_fnc_spawnVehicle;
	private _grp = group (driver (_veh select 0));
	[_veh select 0, _grp] call BIS_fnc_spawnCrew;
	[_grp, getpos _objective] call BIS_fnc_taskAttack;
	_veh;
};

SPAWNFAKEARTY = {
	private _thread = [_this select 0] spawn {
		private _object = _this select 0;
		private _position = getPos _object;
		//private _shellType = ["Sh_82mm_AMOS","Sh_155mm_AMOS"];
		private _shellType = ["Sh_82mm_AMOS"];
		private _hitposition = [];
		private _posToFireAt = [];
		private _shell = "";

		while {alive _object} do { 
			_hitposition = [[[_position, 300]],[[_position, 150]]] call BIS_fnc_randomPos;		
			_posToFireAt = [_hitposition, (random 150), (random 360)] call BIS_fnc_relPos;
			_posToFireAt set [2, 800]; 
			_shell = (selectRandom _shellType) createVehicle _posToFireAt; 
			_shell setPos _posToFireAt; 
			_shell setVelocity [0,0,-200]; 
			sleep (random 30);
		};
	};

	_thread;
};

DELETEALLATTACKERS = {
	{{deleteVehicle _x} foreach (units _x)} foreach HEDES_INF_AI_GROUPS;
	{{deleteVehicle _x} foreach (units _x)} foreach HEDES_VEH_AI_GROUPS;
};
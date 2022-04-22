setacctime 4;

if (!isServer) exitWith {};

_this spawn {
	
	jets = [];

	private _home = nearestBuilding _this;

	private _examplearray = ["B_Plane_CAS_01_dynamicLoadout_F","B_Plane_Fighter_01_F"];
	private _side = WEST;
	private _maxjets = 3;	
	private _timeout = 240;
	private _wpradius = 100;

	// ****************************************************************
	// Private Functions
	// ****************************************************************
	private _newvehicle = {
		_veh = createVehicle [selectRandom _this, [0,0,100], [], 0, "FLY"];
		_veh flyInHeightASL [250, 150, 400];
		_veh setFuel .25;
		_grp = createVehicleCrew _veh;
		_grp deleteGroupWhenEmpty true;
		units _grp apply {_x forceWalk true; _x allowDamage false; removeAllWeapons _x};
		[_veh,_grp, time]
	};

	private _assignland = {
		params["_grp","_obj",["_wpradius",20]];
		
		for "_i" from count waypoints _grp - 1 to 0 step -1 do
			{deleteWaypoint [_grp, _i]};

		_pos = ceil random count(_obj buildingPos -1);		
		_wp1 = _grp addWaypoint [getPos _obj, _wpradius];
		_wp1 setWaypointType "GETOUT";
		_wp1 setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";
		_wp2 = _grp addWaypoint [getPos _obj, _wpradius];
		_wp2 waypointAttachVehicle _obj;
		_wp2 setWaypointHousePosition _pos;
		_wp2 setWaypointStatements ["true", toString {
			if (!isServer) exitWith {};
			thisList apply {(assignedVehicle _x) setVariable ["landed", true]};
			thisList apply {unassignVehicle _x};
			thisList apply {deleteVehicle _x};
		}];
	};

	private _resetjet = {
		params ["_jet","_grp","_time","_home"];

		for "_i" from count waypoints _grp - 1 to 0 step -1 do
			{deleteWaypoint [_grp, _i]};

		_jet setFuel .5;
		_pilot = _grp createUnit ["B_Pilot_F", getPos _home, [], 0, "FORM"];
		_pilot setPos ([_home, 1, 10] call BIS_fnc_findSafePos);
		_pilot assignAsDriver _jet;
		_pilot forceWalk true;
		_pilot allowDamage false;
		units _grp apply {removeBackpack _x};
		units _grp apply {removeAllWeapons _x};
		units _grp orderGetIn true;
		[_grp, getPos _pilot, 2000] call CBA_fnc_taskPatrol;
		_jet setVariable ["landed", false];
	};

	// ****************************************************************
	// Main Loop
	// ****************************************************************
	while {_this isNotEqualTo objNull} do {

		if (simulationEnabled _this) then 
		{
			// -- Create New Groups If Cleaned 
			jets apply {
				if ((_x # 1) isEqualTo grpNull) then { _x set [1, createGroup [_side, true]] };
			};

			// -- Spawn New Jets
			if (count(jets) < _maxjets) then 
			{
				jets pushBack (_examplearray call _newvehicle);
			};

			// -- Recall Low Fuel
			jets select { fuel (_x # 0) < .25 } apply 
			{ 
				[(_x # 1), _home] call _assignland;
				_x set [2, time];
			};

			// -- Assign New Crew
			jets select {((assignedDriver (_x # 0)) == objNull or count(units(_x # 1)) == 0) && (_x # 0) getVariable "landed"} apply
			{
				if(damage (_x # 0) isEqualTo 0 and (_x # 0) isNotEqualTo objNull) then {
					(_x + [_home]) call _resetjet;
					_x set [2, time];
				} else {	
					deleteVehicle (_x # 0);
					units (_x # 1) apply {deleteVehicle _x};
				};
			};

			// -- Something Wrong Conditions 
			jets select {
				_x params ["_jet","_grp","_time"];	
				(							
					(damage _jet) > .05 or 										// Jet Destroyed 
					_jet isEqualTo objNull or									// Jet Is Gone
					(count(units _grp select {damage _x isEqualTo 1}) > 0) or	// Crew Died 
					count(units _grp) isEqualTo 0 or							// Crew Never Showed Up
					!((assignedDriver _jet) in _jet)							// Crew Not In Jet
				) && (_time + _timeout < time)
			} apply {
				_x params ["_jet","_grp","_time"];
				deleteVehicle _jet;
				units _grp apply {deleteVehicle _x};
				
				jets = jets - [_x];
			};

			sleep 30;
		};
	};
};
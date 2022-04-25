/*
---------------------------------------------
Airport Sim Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

_logic spawn {

	jets = [];

	private _home = nearestBuilding _this;

	private _cleaners = synchronizedObjects _this select {_x isKindOf QUOTE(GVAR(Cleaner))};
	private _spawners = synchronizedObjects _this select {_x isKindOf QUOTE(GVAR(SpawnPoint))};
	private _despawners = synchronizedObjects _this select {_x isKindOf QUOTE(GVAR(DespawnPoint))};
	private _area = [50,50,1,false];
	private _jetunits = [];

	private _unitpool = call compile (_this getVariable ["UnitPool","[]"]);
	private _side = call compile (_this getVariable ["UnitSide","WEST"]);
	private _init = compile (_this getVariable ["UnitInit",""]);
	private _mission = _this getVariable ["MissionType",3];	
	private _maxjets = _this getVariable ["NumberOfUnits",3];	
	private _timeout = _this getVariable ["UnitTimeout",240];
	private _wpradius = _this getVariable ["WPRadius",100];
	private _maxfuel = _this getVariable ["MaxFuel",.25];
	private _minfuel = _this getVariable ["MinFuel",.15];

	// ****************************************************************
	// Private Functions
	// ****************************************************************
	private _newvehicle = {
		_pos = getPos (selectRandom _spawners);
		_jet = createVehicle [selectRandom _this, _pos, [], 0, "FLY"];
		_dir = _home getRelDir _jet;
		_get setDir _dir;
		_jet flyInHeightASL [250, 150, 400];
		_jet setFuel _minfuel;
		_jet setVariable ["landing", false];
		_grp = createVehicleCrew _jet;
		_grp deleteGroupWhenEmpty true;
		units _grp apply {_x forceWalk true; _x allowDamage false; removeAllWeapons _x};

		_jet,_grp call _init;

		[_jet,_grp, time]
	};

	private _assignland = {
		params["_grp","_obj",["_wpradius",20]];
		
		for "_i" from count waypoints _grp - 1 to 0 step -1 do
			{deleteWaypoint [_grp, _i]};

		units _grp apply {(assignedVehicle _x) setVariable ["landing", true]};

		_pos = ceil random count(_obj buildingPos -1);		
		_wp1 = _grp addWaypoint [getPos _obj, 5];
		_wp1 setWaypointType "GETOUT";
		_wp1 setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";
		_wp2 = _grp addWaypoint [getPos _obj, _wpradius];
		_wp2 waypointAttachVehicle _obj;
		_wp2 setWaypointHousePosition _pos;
		_wp2 setWaypointStatements ["true", toString {
			if (!isServer) exitWith {};
			thisList apply {unassignVehicle _x};
			thisList apply {deleteVehicle _x};
		}];
	};

	private _resetjet = {
		params ["_jet","_grp","_time","_home"];

		for "_i" from count waypoints _grp - 1 to 0 step -1 do
			{deleteWaypoint [_grp, _i]};

		_jet setFuel _maxfuel;
		_pilot = _grp createUnit ["B_Pilot_F", getPos _home, [], 0, "FORM"];
		_pilot setPos (_home buildingExit 0);
		_pilot assignAsDriver _jet;
		_pilot forceWalk true;
		_pilot allowDamage false;
		units _grp apply {removeBackpack _x};
		units _grp apply {removeAllWeapons _x};
		units _grp orderGetIn true;

		switch (_mission) do {
			case "Patrol": {
				[_grp, getPos _pilot, 2000] call CBA_fnc_taskPatrol
			};
			case "Ambient": {
				_pos = getPos (selectRandom _despawners);
				_wp = _grp addWaypoint [_pos, _wpradius];
				_wp setWaypointType "MOVE";
				_wp setWaypointStatements ["true", toString {
					if (!isServer) exitWith {};
					thisList apply {deleteVehicle (vehicle _x)};
					thisList apply {deleteVehicle _x};;
				}];
			};
			default { };
		};

		_jet setVariable ["landing", false];
	};

	// ****************************************************************
	// Main Loop
	// ****************************************************************
	while {_this isNotEqualTo objNull} do {

		if (simulationEnabled _this) then 
		{
			// -- Cleanup Runways 
			_jetunits = [];
			jets apply {_x # 1} apply {units _x apply {_jetunits pushback _x}} ;
			{
				_area = [getPos _x]; 
				_area append (_x getvariable ["objectArea",[50,50,1,false]]);
				_sidea = (_area # 1);
				_sideb = (_area # 2);
				_radius = (sqrt((_sidea^2)*(_sideb^2)))/2;

				_tocleanup = (_this nearObjects _radius) inAreaArray _area 
					select {gettext (configFile >> "CfgVehicles" >> (typeof _x) >> "vehicleClass") isEqualTo "Objects"};

				_tocleanup append ((_this nearEntities [["Car", "Plane", "Tank", "Man"], _radius]) inAreaArray _area
					select {
						_veh = _x;
						!(_veh in allPlayers) and 						// Is not a player
						!(_veh in (jets apply {_x # 0})) and 			// Is not a jet part of sim
						!(_veh in _jetunits) and						// Is not a pilot/crew
						(count(allPlayers select {_x in _veh}) isEqualTo 0)	// Is not a vehicle driven by player
			 		});
					
				_tocleanup apply {deleteVehicle _x};
			} foreach _cleaners;

			// -- Create New Groups If Cleaned 
			jets apply {
				if ((_x # 1) isEqualTo grpNull) then { _x set [1, createGroup [_side, true]] };
			};

			// -- Spawn New Jets
			if (count(jets) < _maxjets) then 
			{
				jets pushBack (_unitpool call _newvehicle);
			};

			// -- Recall Low Fuel
			jets select { fuel (_x # 0) < _minfuel && !((_x # 0) getVariable "landing")} apply 
			{ 
				[(_x # 1), _home] call _assignland;
				_x set [2, time];
			};

			// -- Assign New Crew
			jets select {((assignedDriver (_x # 0)) isEqualTo objNull or count(units(_x # 1)) isEqualTo 0) && (_x # 0) getVariable "landing"} apply
			{
				if(damage (_x # 0) isEqualTo 0 and (_x # 0) isNotEqualTo objNull) then {
					(_x + [_home]) call _resetjet;
					_x set [2, time];
				} else {	
					deleteVehicle (_x # 0);
					units (_x # 1) apply {deleteVehicle _x};
				};
			};

			// -- Tracking Array Cleanup 
			jets = jets - (jets select {(_x # 0) isEqualTo objNull});
			jets = jets - (jets select {(_x # 1) isEqualTo grpNull});

			// -- Something Wrong Conditions 
			jets select {
				_x params ["_jet","_grp","_time"];	
				(							
					(damage _jet) > .05 or 										// Jet Destroyed 
					_jet isEqualTo objNull or									// Jet Is Gone
					(count(units _grp select {damage _x isEqualTo 1}) > 0) or	// Crew Died 
					count(units _grp) isEqualTo 0								// Crew Never Showed Up					
				) or (
					(
						(!((assignedDriver _jet) in _jet) && !(_jet getVariable "Landing"))	// Crew Not In Jet & Is Not Landing Routine
					)
					&& (_time + _timeout < time)
				)
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
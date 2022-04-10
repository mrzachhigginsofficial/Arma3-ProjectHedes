/*
---------------------------------------------
Initializes Combat Zone Manager Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};


private _logic = param [0, objNull];

_logic spawn {

	// ******************************************************************
	// Build Combat Zone Configuration
	// Notes: Create 3 arrays of combat zone settings from the module.
	//		This includes unit pool configuration, max units per side,
	//		and the type of vehicle they should arrive on.
	// ******************************************************************

	// -- Side Configuration Settings
	private _eastConfiguration = [
		east,
		_this getVariable ["EastVehicle",""], 
		_this getVariable ["EastUnitPool",""],
		getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_EastSpawn" })),
		_this getVariable ["EastIsHeli",true], 
		_this getVariable ["EastMaxUnits",80], 
		[], 
		0];
	private _westConfiguration = [
		west, 
		_this getVariable ["WestVehicle",""],
		_this getVariable ["WestUnitPool",""],
		getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_WestSpawn" })),
		_this getVariable ["WestIsHeli",true], 
		_this getVariable ["WestMaxUnits",80], 
		[], 
		120];
	private _guerConfiguration = [
		independent, 
		_this getVariable ["GUERVehicle",""], 
		_this getVariable ["GUERUnitPool",[]],
		getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_GuerSpawn" })),
		_this getVariable ["GUERIsHeli",true], 
		_this getVariable ["GUERMaxUnits",80], 
		[],	
		-120];

	// -- General Configuration Settings
	private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" };
	private _combatzonemarker = createMarker [format["CombatZoneMarker-%1",netId _this], [0,0,0]];
	_combatzonemarker setMarkerType "hd_objective";

	// -- Dynamic Function To Stop Simulation Until Needed Based on Dynamic Simulation Distance
	private _IsPlayerNearSquad = {
		params["_pvtgrp"];
		(count(allPlayers select {
			private _playereval = _x;
			count(units _pvtgrp select {(_x distance _playereval) < (dynamicSimulationDistance "Group")}) > 0;
		})) > 0;
	};

	private _CustomSquadDynamicSimulator = {
		params["_evaluator", "_squad","_isheli"];

		if !(_isheli) then {
			while {
				count((units _squad) select {getPosATL _x select 2 > .5 }) > 0
			} do { 
				sleep 1; 
			};
		};

		while {_squad != grpNull} do
		{
			if ([_squad] call _evaluator) then 
			{
				(units _squad) apply {_x enableSimulationGlobal true};
			} else {
				(units _squad) apply {_x enableSimulationGlobal false};
			};

			sleep 5;
		};
	};

	// ******************************************************************


	// ******************************************************************
	// -- Start Main Loop
	// ******************************************************************
	while {true} do {
		private _combatzone = selectRandom _points;
		_combatzonemarker setMarkerPos (getPos _combatzone);

		{
			private _config = _x;
			private _combatlz = _combatzone getRelPos [400, _config # 7]; //attempt to keep enemies from landing on eachother

			// -- Filter Out Dead/Null
			_config set [6,((_config # 6) - [objNull]) select {alive _x}];

			if(count(_config # 6) < _config # 5) then
			{
				// -- Spawn Vehicle With Crew and Fireteams
				private _groups = [_config # 0, _config # 1, call compile(_config # 2), _config # 3] call FUNCMAIN(SpawnVehicleAndCrew);
				
				// -- Set Group Objectives
				_groups apply {_x allowFleeing 0};
				units(_groups # 0) apply {_x disableAI "SUPPRESSION"};
				units(_groups # 0) apply {_x disableAI "RADIOPROTOCOL"};
				units(_groups # 0) apply {_x disableAI "MINEDETECTION"};
				(_groups + [_combatlz, _x # 3, _x # 4]) spawn FUNCMAIN(FlightPlanner);
				[_groups # 1, getPos _combatzone] call BIS_fnc_taskAttack; 

				// -- Add Units To Cleanup
				[_IsPlayerNearSquad, _groups # 1, _x # 4] spawn _CustomSquadDynamicSimulator;
				(vehicle (leader (_groups # 0))) call FUNCMAIN(AppendCleanupSystemObjects);
				_groups call FUNCMAIN(AppendCleanupSystemObjects);

				// -- Add New Units To Active Unit Array
				_groups apply {(_config # 6) append (units _x)};				
			};

			// -- Be nice to the server
			sleep 1;

		} foreach [_eastConfiguration, _westConfiguration, _guerConfiguration];
		
		sleep 30;
	};
	// ******************************************************************
};
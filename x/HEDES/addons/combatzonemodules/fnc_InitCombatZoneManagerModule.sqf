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

	// -- Build Side Configuration Settings
	private _sideconfigs = [];

	// -- Add East
	private _eastSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_EastSpawn" });
	if(count(_eastSpawns) > 0) then 
	{
		_sideconfigs pushback [
			east, 									// 0 - Side
			_this getVariable ["EastVehicle",""], 	// 1 - Delivery Vehicle Type
			_this getVariable ["EastUnitPool",""], 	// 2 - Pool Unit Types
			getPos (selectRandom _eastSpawns), 		// 3 - Spawn Point
			_this getVariable ["EastIsHeli",true], 	// 4 - Is this a heli/plane
			_this getVariable ["EastMaxUnits",80], 	// 5 - Max number of units
			[], 									// 6 - Unit Tracker
			0];										// 7 - Angle
	};

	// -- Add West
	private _westSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_WestSpawn" });
	if(count(_westSpawns) > 0) then 
	{
		_sideconfigs pushback [
			west,  									// 0 - Side
			_this getVariable ["WestVehicle",""],  	// 1 - Delivery Vehicle Type
			_this getVariable ["WestUnitPool",""],  // 2 - Pool Unit Types
			getPos (selectRandom _westSpawns),  	// 3 - Spawn Point
			_this getVariable ["WestIsHeli",true],  // 4 - Is this a heli/plane
			_this getVariable ["WestMaxUnits",80], 	// 5 - Max number of units
			[], 									// 6 - Unit Tracker
			120];									// 7 - Angle
	};

	// -- Add Independent
	private _guerSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_GuerSpawn" });
	if (count(_guerSpawns) > 0) then 
	{
		_sideconfigs pushback [
			independent,  							// 0 - Side
			_this getVariable ["GUERVehicle",""],  	// 1 - Delivery Vehicle Type
			_this getVariable ["GUERUnitPool",[]],  // 2 - Pool Unit Types
			getPos (selectRandom _guerSpawns),  	// 3 - Spawn Point
			_this getVariable ["GUERIsHeli",true],  // 4 - Is this a heli/plane
			_this getVariable ["GUERMaxUnits",80], 	// 5 - Max number of units
			[], 									// 6 - Unit Tracker
			-120];									// 7 - Angle
	};

	// -- General Configuration Settings
	private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" };
	private _combatzonemarker = createMarker [format["CombatZoneMarker-%1",netId _this], [0,0,0]];

	// --  Main Loop
	while {true} do {
		private _combatzone = selectRandom _points;
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
				[_groups # 1, FUNCMAIN(IsPlayersNearGroup),_x # 4] spawn FUNCMAIN(DynamicSimulation);
				(vehicle (leader (_groups # 0))) call FUNCMAIN(AppendCleanupSystemObjects);
				_groups call FUNCMAIN(AppendCleanupSystemObjects);

				// -- Add New Units To Active Unit Array
				_groups apply {(_config # 6) append (units _x)};				
			};

			// -- Be nice to the server
			sleep 1;

		} foreach _sideconfigs;
		
		sleep 30;
	};
	// ******************************************************************
};
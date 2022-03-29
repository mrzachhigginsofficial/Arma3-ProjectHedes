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

	// Build Configuration
	private _eastConfiguration = [
		east, 
		_this getVariable ["EastVehicle",""], 
		_this getVariable ["EastUnitPool",""],
		getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_EastSpawn" })),
		_this getVariable ["EastIsHeli",true],
		_this getVariable ["EastMaxUnits",80],
		[]];
	private _westConfiguration = [
		west, 
		_this getVariable ["WestVehicle",""], 
		_this getVariable ["WestUnitPool",""],
		getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_WestSpawn" })),
		_this getVariable ["WestIsHeli",true],
		_this getVariable ["WestMaxUnits",80],
		[]];
	private _guerConfiguration = [
		independent, 
		_this getVariable ["GUERVehicle",""], 
		_this getVariable ["GUERUnitPool",[]],
		getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_GuerSpawn" })),
		_this getVariable ["GUERIsHeli",true],
		_this getVariable ["GUERMaxUnits",80],
		[]];

	private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" };
	private _combatzonemarker = createMarker [format["CombatZoneMarker-%1",netId _this], [0,0,0]];
	_combatzonemarker setMarkerType "hd_objective";

	while {true} do {
		private _combatzone = selectRandom _points;
		_combatzonemarker setMarkerPos (getPos _combatzone);
		{
			private _config = _x;

			// Filter Out Dead/Null
			_config set [6,((_config # 6) - [objNull]) select {alive _x}];

			if(count(_config # 6) < _config # 5) then
			{
				// Spawn Vehicle With Crew and Fireteams
				private _groups = [_config # 0, _config # 1, call compile(_config # 2), _config # 3] call FUNCMAIN(SpawnVehicleAndCrew);
				
				// Set Group Objectives
				_groups apply {_x allowFleeing 0};
				units(_groups # 0) apply {_x disableAI "SUPPRESSION"};
				(_groups + [getPos _combatzone, _x # 3, _x # 4]) spawn FUNCMAIN(FlightPlanner);
				[_groups # 1, getPos _combatzone] call BIS_fnc_taskAttack; 

				// Add Units To Cleanup
				(vehicle leader (_groups # 0)) call FUNCMAIN(AppendCleanupSystemObjects);
				_groups call FUNCMAIN(AppendCleanupSystemObjects);

				// Add New Units To Active Unit Array
				_groups apply {(_config # 6) append (units _x)};				
			};

			// Be nice to the server
			sleep 1;

		} foreach [_eastConfiguration, _westConfiguration, _guerConfiguration];
		
		sleep 30;
	};
};
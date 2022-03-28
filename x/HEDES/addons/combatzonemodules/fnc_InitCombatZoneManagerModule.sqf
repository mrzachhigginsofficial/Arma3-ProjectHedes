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
	private _eastspawn = getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_EastSpawn" }));
	private _westspawn = getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_WestSpawn" }));
	private _guerspawn = getPos (selectRandom (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_GuerSpawn" }));
	private _eastConfiguration = [east, _this getVariable ["EastVehicle",""], _this getVariable ["EastUnitPool",""],_eastspawn,_this getVariable ["EastIsHeli",true]];
	private _westConfiguration = [west, _this getVariable ["WestVehicle",""], _this getVariable ["WestUnitPool",""],_westspawn,_this getVariable ["WestIsHeli",true]];
	private _guerConfiguration = [independent, _this getVariable ["GUERVehicle",""],  _this getVariable ["GUERUnitPool",[]],_guerspawn,_this getVariable ["GUERIsHeli",true]];
	private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" };
	private _allgrps = [];
	
	private _combatzonemarker = createMarker [format["CombatZoneMarker-%1",netId _this], [0,0,0]];
	_combatzonemarker setMarkerType "hd_objective";

	while {true} do {
		private _combatzone = selectRandom _points;
		_combatzonemarker setMarkerPos (getPos _combatzone);
		{
			private _groups = [_x # 0, _x # 1, call compile(_x # 2), _x # 3] call FUNCMAIN(SpawnVehicleAndCrew);
			(_groups + [getPos _combatzone, _x # 3, _x # 4]) spawn FUNCMAIN(FlightPlanner);

			_groups apply {_x allowFleeing 0};
			units(_groups # 0) apply {_x disableAI "SUPPRESSION"};
			[_groups # 1, getPos _combatzone] call BIS_fnc_taskAttack; 

			_allgrps append _groups;
		} foreach [_eastConfiguration, _westConfiguration, _guerConfiguration];

		_allgrps call FUNCMAIN(AppendCleanupSystemObjects);
		
		sleep 360;
	};
};
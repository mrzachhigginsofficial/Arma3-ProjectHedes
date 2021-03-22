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
	private _eastConfiguration = [east, _this getVariable ["EastVehicle",""], _this getVariable ["EastUnitPool",""],[worldsize,worldsize,0],_this getVariable ["EastIsHeli",true]];
	private _westConfiguration = [west, _this getVariable ["WestVehicle",""], _this getVariable ["WestUnitPool",""],[worldsize,0,0],_this getVariable ["WestIsHeli",true]];
	private _guerConfiguration = [independent, _this getVariable ["GUERVehicle",""],  _this getVariable ["GUERUnitPool",[]],[0,0,0],_this getVariable ["GUERIsHeli",true]];
	private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" };
	private _combatzone = selectRandom _points;
	{
		private _groups = [_x # 0, _x # 1, call compile(_x # 2), _x # 3] call FUNCMAIN(SpawnVehicleAndCrew);
		(_groups + [getPos _combatzone, _x # 3, _x # 4]) spawn FUNCMAIN(FlightPlanner);

		_groups apply {_x allowFleeing 0};
		units(_groups # 0) apply {_x disableAI "SUPPRESSION"};
		[_groups # 1, getPos _combatzone] call BIS_fnc_taskAttack; 

	} foreach [_eastConfiguration, _westConfiguration, _guerConfiguration];
};
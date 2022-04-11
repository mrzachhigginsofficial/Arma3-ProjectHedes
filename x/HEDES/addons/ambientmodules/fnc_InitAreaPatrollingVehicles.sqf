/*
---------------------------------------------
Initialized Ambient Garrison Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};


private _logic = param [0, objNull, [objNull]];

_logic spawn {
	private _maxvehs = call compile (_this getVariable ["NumberOfvehicles", "5"]);
	private _marker = _this getVariable ["Markername", ""];
	private _speed = _this getVariable ["vehiclespeed", 30];
	private _unitpool = _this getVariable ["UnitPool", []];
	private _veharr = [];

	private _vehicle = objNull;
	private _vehiclegrp = grpNull;
	private _crewarr = [];
	private _neararr = [];
	private _closest = objNull;
	private _newpos = [];

	while {true} do {

		// -- Spawn New Vehicles
		while {count(_veharr) < _maxvehs} do {	

			// -- Find Position To Spawn Vehicle
			private _rndpos = [_marker, true] call FUNCMAIN(FindHiddenRanPosInMarker);

			// -- Spawn Vehicle and Group
			if (_rndpos isNotEqualTo [0,0]) then {				
				private _vehgrp = [_rndpos, random 360, selectRandom(call compile _unitpool), east] call BIS_fnc_spawnvehicle;

				(_vehgrp select 0) forcespeed (call compile _speed);
				(_vehgrp select 0) enableDynamicSimulation true;
				(_vehgrp select 0) call FUNCMAIN(AppendCleanupSystemObjects);
				(_vehgrp select 1) call FUNCMAIN(AppendCleanupSystemObjects);
				(_vehgrp select 2) deleteGroupWhenEmpty true;				
				(_vehgrp select 2) enableDynamicSimulation true;		

				[_vehgrp select 2, FUNCMAIN(IsPlayersNearGroup)] call FUNCMAIN(DynamicSimulation);

				_veharr pushback _vehgrp;
			};
		};


		// -- Action Evaluator
		{
			_vehicle = _x # 0;
			_crewarr = _x # 1;
			_vehiclegrp = _x # 2;

			// -- These conditions make it impossible for the units to complete their task.
			if(
				(assignedDriver _vehicle == objNull) or 	//Driver Missing
				(damage assignedDriver _vehicle == 1) or 	//Driver Dead
				(damage _vehicle == 1) or					//Vehicle Disabled
				(_vehicle == objNull)						//Vehicle Doesn't Exist
			) then {				
				// -- Leave And Try To Join A Surviving Group Within Simulation Range
				_neararr = player nearEntities ["Man", dynamicSimulationDistance "GROUP"] select {side _x == side _vehiclegrp};
				if (count(_neararr) > 0) then {
					_closest = ([_near, [], {_x distance player}, "ASCEND"] call BIS_fnc_sortBy) # 0;

					_crewarr apply {_x action ["Eject", vehicle _x]}; 
					_crewarr select {alive _x} joinSilent (group _closest);
				};
			}

			// -- Move Vehicle To Next Mission If Ready
			else {
				if (speed _vehicle < .5) then {
					_newpos = [[_marker], [], {isOnRoad _this}] call BIS_fnc_randomPos;
					(_x select 2) move _newpos;
					(_x select 0) setFuel 1;
				};
			};
			
		} forEach _veharr;

		sleep 5;
	};
};
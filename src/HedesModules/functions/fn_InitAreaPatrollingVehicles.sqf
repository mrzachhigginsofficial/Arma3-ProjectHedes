/*
--------------------------------------------------------------------
Initialize Ambient Patrol Vehicles Module.

Description:
	Initializes the ambient patrol vehicles module. This runs on the
	server and managers all vehicles. It will make sure there are
	always vehicles patrolling the area. Keep Hedes dangerous.

Notes:
	Iterate this process number of _maxvehs times 
	- Find suitable position (keep trying if [0,0] returned)
	- Spawn Vehicle And Crew 
	- Set Dynamic Simulation and Server Friendly States 
	- Move Vehicle Around Until Destroyed 
	- Spawn Cleanup Threads For Units 
	- Wait 360 seconds.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "..\macros.h"
#include "..\defines.h"

private _logic = param [0, objNull, [objNull]];

private _maxvehs = call compile (_logic getVariable ["NumberOfvehicles", 5]);
private _i = 0;

while {_i < _maxvehs} do
{
	_logic spawn {

		while {true} do
		{
			// -- Get Module Properties
			private _marker = _this getVariable ["Markername", ""];
			private _speed = _this getVariable ["vehiclespeed", 30];
			private _unitpool = _this getVariable ["UnitPool", []];

			// -- Find Position To Spawn Vehicle
			private _rndpos = [0,0];
			while {_rndpos isEqualTo [0,0]} do 
			{
				_rndpos = [[_marker], [], {
					(isOnRoad _this) && (count((_this nearEntities ["Man", 400]) select {
						_x in allplayers
					}) == 0)
				}] call BIS_fnc_randomPos;
				sleep 1;
			};

			private _vehgrp = [_rndpos, random 360, selectRandom(call compile _unitpool), east] call BIS_fnc_spawnvehicle;
				(_vehgrp select 0) forcespeed (call compile _speed);

			// -- Set Dynamic Simulation 
			(_vehgrp select 0) enableDynamicSimulation true;
			(_vehgrp select 1) apply { _x enableDynamicSimulation true };
			(_vehgrp select 2) deleteGroupWhenEmpty true;

			// -- Move Vehicle Around While Vehicle and Driver Alive
			private _crewcount = count(_vehgrp select 1);
			while {(alive (_vehgrp select 0)) && ((count(_vehgrp select 1 select {alive _x})) >= _crewcount)} do {
				private _newpos = [[_marker], [], {
					isOnRoad _this
				}] call BIS_fnc_randomPos;
				(_vehgrp select 2) move _newpos;
				(_vehgrp select 0) setFuel 1;
				sleep 360;
			};

			// -- Move Unit To Global Cleanup Thread
			(_vehgrp select 0) call FUNC(AddUnitToCleanupList);
			(_vehgrp select 1 select {alive _x}) call FUNC(AddUnitToCleanupList);

			sleep 360;
		};
	};

	_i = _i + 1;
};
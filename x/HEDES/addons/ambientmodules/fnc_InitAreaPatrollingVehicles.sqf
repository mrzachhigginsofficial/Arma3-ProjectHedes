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
	private _i = 0;
	while {_i < _maxvehs} do
	{
		

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
				(_vehgrp select 0) call FUNCMAIN(AppendCleanupSystemObjects);
				(_vehgrp select 1 select {alive _x}) call FUNCMAIN(AppendCleanupSystemObjects);

				sleep 360;
			};

		_i = _i + 1;
	};
};
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

	while {true} do {

		if (count(_veharr) < _maxvehs) then {	
			// -- Find Position To Spawn Vehicle
			private _rndpos = [0,0];
			while {_rndpos isEqualTo [0,0]} do 
			{
				_rndpos = [[_marker], [], {
					(isOnRoad _this) && (count((_this nearEntities ["Man", 400] select {_x in allPlayers}) select {
						_x in allplayers
					}) == 0)
				}] call BIS_fnc_randomPos;
				sleep 1;
			};
			// -- Spawn Vehicle and Group
			private _vehgrp = [_rndpos, random 360, selectRandom(call compile _unitpool), east] call BIS_fnc_spawnvehicle;
			(_vehgrp select 0) forcespeed (call compile _speed);
			// -- Set Dynamic Simulation 
			(_vehgrp select 0) enableDynamicSimulation true;
			(_vehgrp select 1) apply { _x enableDynamicSimulation true };
			(_vehgrp select 2) deleteGroupWhenEmpty true;

			(_vehgrp select 0) call FUNCMAIN(AppendCleanupSystemObjects);
			(_vehgrp select 1 select {alive _x}) call FUNCMAIN(AppendCleanupSystemObjects);

			_veharr pushback _vehgrp;
		};
		
		{
			// -- Move Vehicle Around While Vehicle and Driver Alive
			private _crewcount = count(_x select 1);
			if ((alive (_x select 0)) && ((count(_x select 1 select {alive _x})) >= _crewcount)) then {
				private _newpos = [[_marker], [], {
					isOnRoad _this
				}] call BIS_fnc_randomPos;
				(_x select 2) move _newpos;
				(_x select 0) setFuel 1;
			};		
		} forEach _veharr;

		sleep 360;
	};
};
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
	private _side = EAST;
	private _veharr = [];

	private _rndpos = [];
	private _newvehgrp = grpNull;
	private _vehicle = objNull;
	private _vehiclegrp = grpNull;
	private _crewarr = [];
	private _neararr = [];
	private _closest = objNull;
	private _newpos = [];
	private _firstalivecrew = objNull;

	while {true} do 
	{
		// -- Clean Up Vehicle Array 
		_veharr = _veharr - (_veharr select {_x select 0 == objNull}); 		//Remove Missing Vehicles.
		_veharr = _veharr - (_veharr select {damage (_x select 0) == 1}); 	//Remove Dead Vehicles.
		_veharr = _veharr - (_veharr select {count(_x select 1 select {alive _x}) == 0});
		_veharr = _veharr - (_veharr select {_x select 2 == grpNull});

		try 
		{
			// -- Spawn New Vehicles
			while {count(_veharr) < _maxvehs} do {	

				// -- Find Position To Spawn Vehicle
				_rndpos = [_marker, true] call FUNCMAIN(FindHiddenRanPosInMarker);

				// -- Spawn Vehicle and Group
				if (_rndpos isNotEqualTo [0,0]) then {				
					_newvehgrp = [_rndpos, random 360, selectRandom(call compile _unitpool), _side] call BIS_fnc_spawnvehicle;
					
					// -- Put All Units On Correct Side
					_newvehgrp set [2,createGroup _side];
					(_newvehgrp select 1) joinSilent (_newvehgrp select 2);

					(_newvehgrp select 0) forcespeed (call compile _speed);
					(_newvehgrp select 0) enableDynamicSimulation true;
					(_newvehgrp select 0) call FUNCMAIN(AppendCleanupSystemObjects);
					(_newvehgrp select 1) call FUNCMAIN(AppendCleanupSystemObjects);
					(_newvehgrp select 2) deleteGroupWhenEmpty true;				
					(_newvehgrp select 2) enableDynamicSimulation true;		

					[_newvehgrp select 2, FUNCMAIN(IsPlayersNearGroup)] call FUNCMAIN(DynamicSimulation);

					_veharr pushback _newvehgrp;
				};
			};


			// -- Action Evaluator
			{
				_vehicle = _x # 0;
				_crewarr = _x # 1;
				_vehiclegrp = _x # 2;

				// -- These conditions make it impossible for the units to complete their task.
				if(
					count(_crewarr select {alive _x}) > 0 and			// 1. Check If There Are Alive Crewmembers
					(
						(damage assignedDriver _vehicle == 1) or 		// 2. Driver Dead
						(assignedDriver _vehicle == objNull) or 		// 2. Driver Missing
						(_vehicle emptyPositions "Driver") > 0	or		// 2. Driver Is Missing Differently
						(damage assignedGunner _vehicle == 1) or 		// 2. Gunner Dead
						(assignedGunner _vehicle == objNull) or 		// 2. Gunner Missing
						(_vehicle emptyPositions "Gunner") > 0	or		// 2. Gunner Is Missing Differently
						(damage assignedCommander _vehicle == 1) or 		// 2. Commander Dead
						(assignedCommander _vehicle == objNull) or 		// 2. Commander Missing
						(_vehicle emptyPositions "Commander") > 0	or	// 2. Commander Is Missing Differently
						
						(damage _vehicle == 1) or						// 2. Vehicle is Destroyed
						(_vehicle == objNull) 							// 2. Vehicle Doesn't Exist
					)
				) then {				
					// -- Leave And Try To Join A Surviving Group Within Simulation Range
					_firstalivecrew = _crewarr select {alive _x} select 0;
					_neararr = _firstalivecrew nearEntities ["Man", dynamicSimulationDistance "GROUP"] 
						select {alive _x} 
						select {_x isNotEqualTo _firstalivecrew}
						select {side _x == side _firstalivecrew};

					if (count(_neararr) > 0) then {
						_vehiclegrp leaveVehicle _vehicle;
						_closest = ([_neararr, [], {_x distance player}, "ASCEND"] call BIS_fnc_sortBy) # 0;
						_crewarr apply {_x action ["Eject", vehicle _x]}; 
						_crewarr select {alive _x} joinSilent (group _closest);

						_vehicle spawn {
							private _i = 0;
							private _s = objNull;
							while {_i < 20} do 
							{
								 _s = _this say3D "Beep";
								sleep 1;
								deleteVehicle _s;
								_i = _i + 1;
							};
							_this setDamage 1;
						}
					};
				} 
				
				// -- We Can Move On
				else {
					// -- Move Vehicle To Next Mission If Ready
					if (count(_crewarr select {alive _x}) > 0) then {
						if (speed _vehicle < .5) then {
							_newpos = [[_marker], [], {isOnRoad _this}] call BIS_fnc_randomPos;
							(_x select 2) move _newpos;
							(_x select 0) setFuel 1;
						};
					} 
					// -- No Idea What's Going On, Just Delete It All
					else 
					{
						_vehicle setDamage 1;
						_crewarr apply {deleteVehicle _x};
					}
				}

			} forEach _veharr;
		}
		catch
		{
			if isServer then
			{
				systemChat format["Error: %1", _exception];
			};
		};
		
		sleep 5;
	};
};
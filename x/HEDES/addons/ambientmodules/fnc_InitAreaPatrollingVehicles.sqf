/*
---------------------------------------------
Initialized Ambient Garrison Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];

/*
--------------------------------------------------------------------
Main Thread
--------------------------------------------------------------------
*/

_logic spawn {

	// Initialize Variables
	private _rndpos = [];
	private _newvehgrp = grpNull;
	private _vehicle = objNull;
	private _vehiclegrp = grpNull;
	private _crewarr = [];
	private _neararr = [];
	private _closest = objNull;
	private _newpos = [];
	private _firstalivecrew = objNull;
	private _i = 0;
	private _maxtry = 5;
	private _isfirstspawn = 1;

	// Get Module Properties
	private _newunitinitfnc = compile(_this getVariable ["UnitInit", ""]);
	private _maxvehs = _this getVariable ["NumberOfvehicles", 5];
	private _speed = _this getVariable ["vehiclespeed", "LIMITED"];
	private _unitpool = _this getVariable ["UnitPool", []];
	private _side = call compile (_this getVariable ["UnitSide", "EAST"]);
	private _areatriggers = synchronizedObjects _this select {_x isKindOf "EmptyDetector"} apply {[_x, []]};
	private _interval = _this getVariable ["SimulationInterval",15];

	// Create Simulation Thread 
	private _maintenanceid = ["AMBIENTVEHSIMTHREAD",0] call FUNCMAIN(CreateDynamicSimulationThread);

	// Initialize Trigger Area	
	if (count(_areatriggers) == 0) then 
	{
		private _newtrigger = createtrigger ["emptydetector",position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger setPos (getPos _this);
		_areatriggers pushback [_newtrigger,[]];
	};

	// Disable Simulation on Triggers
   {
      (_x # 0) enableSimulationGlobal false;
   } foreach _areatriggers;

	// Main Loop
	while {_this isNotEqualTo objNull} do 
	{
		if(simulationEnabled _this) then
		{
			if !(isNil "HEDES_DEBUG") then {systemchat format["%1 fired with interval of %2.",_this, _interval]};

			// Iterate Over Each Trigger Area 
			{
				_trigger = _x # 0;
				_veharr = _x # 1;

				// Spawn New Vehicles
				try
				{
					_i = 0;
					while {count(_veharr) < _maxvehs && _i < _maxtry} do
					{	
						// Find Random Position					
						_rndpos = if(_isfirstspawn == 1) then {
							[_trigger call BIS_fnc_randomPosTrigger, 5, 50, 10] call BIS_fnc_findSafePos
						} else {
							[_trigger, true] call FUNCMAIN(FindHiddenRanPosInMarker)
						};

						// Spawn Vehicle and Group
						if (_rndpos isNotEqualTo [0,0]) then 
						{				
							_newvehgrp = [_rndpos, random 360, selectRandom(call compile _unitpool), _side] call BIS_fnc_spawnvehicle;
							
							// Put All Units On Correct Side
							_newvehgrp set [2,createGroup _side];
							(_newvehgrp select 1) joinSilent (_newvehgrp select 2);
							(_newvehgrp select 0) forcespeed (call compile _speed);
							(_newvehgrp select 0) call FUNCMAIN(AppendCleanupSystemObjects);
							(_newvehgrp select 1) call FUNCMAIN(AppendCleanupSystemObjects);

							// Unit Init
							(_newvehgrp select 1) apply {_x call _newunitinitfnc};

							[_maintenanceid, _newvehgrp select 2] call FUNCMAIN(AppendDynamicSimulation);

							_veharr pushback _newvehgrp;
						};
						_i = _i + 1;
					};
				}
				catch {
					_exception call BIS_fnc_log
				};

				// Action Evaluator
				{
					try	
					{
						_vehicle = _x # 0;
						_crewarr = _x # 1;
						_vehiclegrp = _x # 2;

						// These conditions make it impossible for the units to complete their task.
						if(
							count(_crewarr select {alive _x}) > 0 and			// 1. Check If There Are Alive Crewmembers
							(
								(damage assignedDriver _vehicle == 1) or 		// 2. Driver Dead
								(assignedDriver _vehicle == objNull) or 		// 2. Driver Missing
								(_vehicle emptyPositions "Driver") > 0	or		// 2. Driver Is Missing Differently
								(damage assignedGunner _vehicle == 1) or 		// 2. Gunner Dead
								(assignedGunner _vehicle == objNull) or 		// 2. Gunner Missing
								(_vehicle emptyPositions "Gunner") > 0	or		// 2. Gunner Is Missing Differently
								(damage assignedCommander _vehicle == 1) or 	// 2. Commander Dead
								(assignedCommander _vehicle == objNull) or 	// 2. Commander Missing
								(_vehicle emptyPositions "Commander") > 0	or	// 2. Gunner Is Missing Differently
								(damage _vehicle == 1) or							// 2. Vehicle is Destroyed
								(_vehicle == objNull) 								// 2. Vehicle Doesn't Exist
							)
						) then 
						{				
							// Leave And Try To Join A Surviving Group Within Simulation Range
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
							};

							_vehicle spawn {
								private _i = 0;
								while {_i < 20} do 
								{
									_this say3D "Beep";
									sleep 1;
									_i = _i + 1;
								};
								_this setDamage 1;
							}
						} 
						// We Can Move On
						else 
						{
							if (speed _vehicle < .5) then 
							{
								_radius = [_trigger] call FUNCMAIN(FindHypotenuse);
								_roads = _trigger nearRoads (_radius/2);

								if (count(_roads) > 0) then 
								{
									_newpos = getPos(selectRandom _roads);
									(_x select 2) move _newpos;
									(_x select 0) setFuel 1;
								};
							};
						};
					}
					catch
					{
						_exception call BIS_fnc_log;
					}

				} forEach _veharr;

				// Update Vehicle Array
				_veharr = _veharr - (_veharr select {_x select 0 == objNull}); 		//Remove Missing Vehicles.
				_veharr = _veharr - (_veharr select {damage (_x select 0) == 1}); 	//Remove Dead Vehicles.
				_veharr = _veharr - (_veharr select {count(_x select 1 select {alive _x}) == 0});
				_veharr = _veharr - (_veharr select {_x select 2 == grpNull});
				_x set [1, _veharr];

			} foreach _areatriggers;

			_isfirstspawn = 0;
		};		

		// Go to sleep for a bit.
		sleep _interval;
	};
};
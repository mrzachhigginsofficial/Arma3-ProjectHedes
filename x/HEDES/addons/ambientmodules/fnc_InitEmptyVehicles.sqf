/*
---------------------------------------------
Initialized Ambient Empty Vehicles Module
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
	private _pos = [0,0];
	private _posi = 0;
	private _vehi = 0;
	private _maxtryveh = 20;
	private _maxtrypos = 20;
	private _trigger = objNull;
	private _vehtracker = [];
	private _direction = 0;
	private _road = objNull;
	private _roadConnectedTo = objNull;
	private _connectedRoad = objNull;
	private _veh = objNull;
	private _randomPosEval = {};
	private _isfirstspawn = 1;
	private _debugveh = objNull;

	// Get Module Properties
	private _newunitinitfnc = compile(_this getVariable ["UnitInit", ""]);
	private _numveh = _this getVariable ["NumOfVehs",5];
	private _unitpool = call compile (_this getVariable "UnitPool");
	private _areatriggers = synchronizedObjects _this select {_x isKindOf "EmptyDetector"};
	private _interval = _this getVariable ["SimulationInterval",15];

	// Initialize Trigger Area	
	if (count(_areatriggers) == 0) then 
	{
		private _newtrigger = createtrigger ["emptydetector",position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger setPos (getPos _this);
		_areatriggers append [_newtrigger];
	};

	// Disable Simulation on Triggers
   {
      (_x # 0) enableSimulationGlobal false;
   } foreach _areatriggers;

	// Main Loop
	while {_this isNotEqualTo ObjNull} do 
	{
		if (simulationEnabled _this) then
		{
			// Iterate through default or synchronized triggers.
			{
				_trigger = _x;

				_randomPosEval = if (_isfirstspawn == 1) then {
					{isOnRoad _this}
				} else {
					{isOnRoad _this && !([_this] call FUNCMAIN(IsPlayersNearObj))}
				};
				
				if (simulationEnabled _trigger) then
				{
					_vehi = 0;
					while {_numveh > count(_vehtracker select {alive _x} select {[_trigger, _x] call BIS_fnc_inTrigger }) && _vehi < _maxtryveh} do
					{
						_pos = [0,0];
						_posi = 0;
						
						while {_pos isEqualTo [0,0] && _posi < _maxtrypos} do {
							_pos = [[_trigger], [], _randomPosEval] call BIS_fnc_randomPos;
							_posi = _posi + 1;
						};

						if !(_pos isEqualTo [0,0]) then {
							// Spawn New Truck That Looks Believable
							_direction = random 360;
							_road = roadAt _pos;
							_roadConnectedTo = roadsConnectedTo _road;
							_connectedRoad = _roadConnectedTo select 0;
							if (!isNil "_connectedRoad") then {
								_direction = [_road, _connectedRoad] call BIS_fnc_DirTo;
							};
							_veh = (selectRandom(_unitpool) createVehicle _pos);
							_veh setDir _direction;
							
							// Maintenance Stuff
							_veh enableDynamicSimulation true;
							_veh call FUNCMAIN(AppendCleanupSystemObjects);
							_vehtracker pushBack _veh;

							// Run Init Function
							_veh call _newunitinitfnc;
						};

						_vehi = _vehi + 1;
					};
				};			
			} foreach _areatriggers;

			// Remove vehicles that are GC'd or cleaned up.
			_vehtracker = _vehtracker - [objNull];

			_isfirstspawn = 0;
		};

		// Go to sleep for a bit.
		sleep _interval;		
	};
};
/*
---------------------------------------------
Initialized Ambient Vehicles Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];

_logic spawn {

	while {_this isNotEqualTo ObjNull} do {

		if(simulationEnabled _this)
		{
			
			private _marker = _this getVariable "MarkerName";
			private _numveh = call compile (_this getVariable "NumOfVehs");
			private _unitpool = call compile (_this getVariable "UnitPool");
			private _vehtracker = [];

			if (
				_numveh > count(
					_vehtracker select {
						alive (_x select 0)} select {
							(((getpos (_x select 0)) distance (_x select 1))) < 300})
			) then
			{
				private _pos = [0,0];
				while {_pos isEqualTo [0,0]} do {
					_pos = [[_marker], [], {isOnRoad _this}] call BIS_fnc_randomPos;
				};

				private _direction = random 360;
				private _road = roadAt _pos;
				private _roadConnectedTo = roadsConnectedTo _road;
				private _connectedRoad = _roadConnectedTo select 0;
				if (!isNil "_connectedRoad") then {
					_direction = [_road, _connectedRoad] call BIS_fnc_DirTo;
				};
				private _veh = (selectRandom(_unitpool) createVehicle _pos);
				_veh setDir _direction;
				_veh enableDynamicSimulation true;

				_vehtracker = _vehtracker select {
					!((_x select 0) isEqualTo objNull)} select {
						(getpos (_x select 0)) distance (_x select 1) < 300};
				_vehtracker pushBack [_veh,_pos];
			};

			sleep 15;
		};
	};
};
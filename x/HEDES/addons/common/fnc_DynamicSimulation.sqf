/*
---------------------------------------------
Custom Dynamic Simulation - Used because the 
	standard Arma 3 dynamic simulation doesn't
	seem to disable units if they have waypoints.
Author: ZanchoElGrande

Set _isinplane if units are going to parachute out.
---------------------------------------------
*/

#include "script_component.hpp"

params["_var",["_evaluator",FUNCMAIN(IsPlayersNearGroup)],["_isinplane", false]];

// ***************************************************
// -- Group Simulation Loop
// ***************************************************
private _GroupSimulationLoop = {
	params["_grp","_evaluator","_isinplane"];

	if (_isinplane) then {
		while {
			(count((units _grp) select {getPosATL _x select 2 > .5 })) > 0
		} do { 
			sleep 1; 
		};
	};

	while {_grp != grpNull} do
	{
		if ([_grp] call _evaluator) then 
		{
			(units _grp) apply {_x enableSimulationGlobal true};
		} else {
			(units _grp) apply {_x enableSimulationGlobal false};
		};

		sleep 2;
	};
};

// ***************************************************
// -- Object Simulation Loop
// ***************************************************
private _ObjectSimulationLoop = {
	params["_obj","_evaluator","_isinplane"];

	if (_isinplane) then {
		while {
			((getPosATL _obj) select 2) > .5
		} do { sleep 1; };
	};

	while {_obj != objNull} do
	{
		if ([_obj] call _evaluator) then 
		{
			_obj enableSimulationGlobal true;
		} else {
			_obj enableSimulationGlobal false;
		};

		sleep 2;
	};
};

// ***************************************************
// -- Spawn Proper Simulation Thread
// ***************************************************

sleep 10; // -- Give Unit Or Group Chance To Setup

switch (typeName _var) do {
	case "GROUP" : { 
			[_var, _evaluator, _isinplane] spawn _GroupSimulationLoop; 
		};
	case "OBJECT" : { 
			[_var, _evaluator, _isinplane] spawn _ObjectSimulationLoop; 
		};
};
/*
---------------------------------------------
Spawns Combat Zone Vehichle and Crew
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

params["_side","_veh","_unitpool","_spawnpoint"],;

private _plane = createVehicle [_veh, _spawnpoint, [], 0, "FLY"]; 
private _planecrewtemp = createVehicleCrew _plane;    
private _planecrewgrp = createGroup [_side, true];

(units _planecrewtemp) joinSilent _planecrewgrp;
_planecrewgrp setBehaviour "CARELESS";
_plane setSpeedMode "FULL";

private _passengergrp = createGroup [_side, true];
private _maxpassengers = count(fullCrew [_plane, "cargo", true]);
private _i = 0;
while {_i < _maxpassengers} do 
{
	private _unit = _passengergrp createUnit [selectRandom _unitpool, position _plane, [], 0, "CARGO"];
	_unit moveInCargo _plane;
	_i = _i + 1;
};

[_planecrewgrp, _passengergrp]
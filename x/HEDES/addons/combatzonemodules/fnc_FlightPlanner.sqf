/*
---------------------------------------------
Flight Planner
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

params[
	"_planecrewgrp",
	"_passengergrp",
	"_droppoint",
	"_spawnpoint",
	"_isheli"];

private _vehicle = vehicle (leader _planecrewgrp);

private _wp1 = _planecrewgrp addwaypoint [_droppoint, 150];
private _wp1statement = "";

if (_isheli) then 
{
	_wp1 setWaypointType "TR UNLOAD";  
	_wp1statement = QUOTE(_plane = vehicle this; _plane spawn FUNCMAIN(DismountUnits););
} else {
	_wp1 setWaypointType "MOVE";
	_wp1statement = QUOTE(_plane = vehicle this; _plane spawn FUNCMAIN(ParachuteUnits););
};

_wp1 setWaypointStatements ["true",	_wp1statement];	

while {count(assignedCargo _vehicle) > 0 } do {sleep 5};

private _wp2 = _planecrewgrp addwaypoint [_spawnpoint,5]; 
_wp2 setWaypointType "MOVE";    
_wp2 setWaypointStatements ["true",	"_veh = vehicle this; { _veh deleteVehicleCrew _x } foreach (units this); deleteVehicle _veh;"];
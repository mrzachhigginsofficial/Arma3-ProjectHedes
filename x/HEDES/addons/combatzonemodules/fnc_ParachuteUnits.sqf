/*
---------------------------------------------
Parachutes Units From Vehicle (Plane)
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};
	
private _vehicle = _this;
private _grp = group (assignedCargo _vehicle select 0);

{
	_x disableCollisionWith _vehicle; removeBackpack _x;
	_x addBackPack "B_parachute";
	unassignVehicle _x;	moveOut _x;
	sleep .3;
} foreach (units _grp);
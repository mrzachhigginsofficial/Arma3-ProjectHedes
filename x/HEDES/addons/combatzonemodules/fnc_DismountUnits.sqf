/*
---------------------------------------------
Forces Units To Dismount (Heli)
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _vehicle = _this;
private _grp = group (assignedCargo _vehicle select 0);

_vehicle land "LAND";
while { getPosATL _vehicle select 2 > .5  } do { sleep 5 };

units _grp apply {
	_x disableCollisionWith _vehicle;
	unassignVehicle _x;	moveOut _x;
	sleep .2;
};
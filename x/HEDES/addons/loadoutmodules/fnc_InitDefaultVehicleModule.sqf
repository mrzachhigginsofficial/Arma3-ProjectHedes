/*
---------------------------------------------
Init Default Vehicle Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

private _logic = param [0, objNull, [objNull]];
private _vehicle = _logic getVariable "DefaultVeh";
private _actionobject = synchronizedObjects _logic;

ISNILS(GVAR(ALLVEHICLENAMEPLATES),[]);

{
	GVAR(ALLVEHICLENAMEPLATES) pushback _x;
	[
		_x, ["Give me a ride...", { 
			private _veh = (_this select 3);
			private _player = (_this select 1);
			private _pos = position _player;
			private _veh = (_veh createVehicle _pos);
			_player moveInDriver _veh;
			_veh setPos _pos;
		}, _vehicle, 1.5, true, true, "", "true", 10]
	] remoteExec ["addAction",0,true];
} foreach _actionobject;
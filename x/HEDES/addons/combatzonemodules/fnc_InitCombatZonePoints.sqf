/*
---------------------------------------------
Initializes Combat Points & LZ's
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" };
{
	private _point = _x;
	private _trigger = _point call FUNCMAIN(CreateModuleTrigger);
	_point setVariable ["trigger",_trigger];

	{
		{
			_x setVariable ["trigger",_x call FUNCMAIN(CreateModuleTrigger)];
		} foreach synchronizedObjects _point select { typeOf _x == format["HEDES_CombatZoneModules_%1LZ",_x] };
	} foreach ["EAST", "WEST", "GUER"];
} foreach _points;

_points
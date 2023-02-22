/*
---------------------------------------------
Initializes Combat Zone Manager Configuration
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

// Build Side Configuration Settings
private _sideconfigs = [];
{
	private _spawntype = format["HEDES_COMBATZONEMODULES_%1Spawn",_x];
	private _spawns = (synchronizedObjects _this select { typeOf _x == _spawntype });

	if(count(_spawns) > 0) then 
	{
		_sideconfigs pushback [
			if (_x isNotEqualTo "Guer") then {call compile _x} else {independent}, //Because we aren't renaming this module again
			_this getVariable [format["%1Vehicle",_x],""],
			call compile (_this getVariable [format["%1UnitPool",_x],""]),
			_spawns apply {getPos _x},
			_this getVariable [format["%1SpawnerType",_x],"HeliLand"],
			_this getVariable [format["%1MaxUnits",_x],80],[],[],
			_this getVariable [format["%1UnitInit",_x],"null"],
			_this getVariable [format["%1OrderOverride",_x],false]
		];
	};
} foreach ["East","West","Guer"];

_sideconfigs
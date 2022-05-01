/*
---------------------------------------------
Destruction Module Client
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

_logic spawn {

	private _sound = _this getVariable "SoundEffect";

	_eval = format ["getText(_x >> 'sound') == '%1'", _sound];
	_soundref = configName((_eval configClasses(configfile >> "CfgVehicles")) # 0);

	createSoundSource [_soundref, position _this, [], 0];
};
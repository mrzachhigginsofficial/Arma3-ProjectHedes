/*
---------------------------------------------
Sound Source Server
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

private _logic = param [0, objNull];

_logic spawn {
	private _sound = _this getVariable "SoundEffect";
	private _soundradius = getArray (configfile >> "CfgSFX" >> _sound >> "Sound0") # 3;
	private _trigger = createTrigger ["EmptyDetector", getPosWorld _this, true];
	_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
	_trigger setTriggerArea [_soundradius * 2, _soundradius * 2, 0, false, -1];
	_trigger setTriggerInterval .25;
	_trigger setSoundEffect ["", "", "", _sound];
	_trigger setTriggerStatements ["player in thisList", "", ""];
};
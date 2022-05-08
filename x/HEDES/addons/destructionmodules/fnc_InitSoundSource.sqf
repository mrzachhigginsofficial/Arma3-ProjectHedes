/*
---------------------------------------------
Sound Source Server
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

private _position = getPos _logic;
private _sound = _logic getVariable "SoundEffect";
private _soundradius = getArray (configfile >> "CfgSFX" >> _sound >> "Sound0") # 3;

_initsoundfnc = {
	params ["_position","_sound","_soundradius"];

	private _trigger = createTrigger ["EmptyDetector", _position, false];
	_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
	_trigger setTriggerArea [_soundradius * 2, _soundradius * 2, 0, false, -1];
	_trigger setTriggerInterval .25;
	_trigger setSoundEffect ["", "", "", _sound];
	_trigger setTriggerStatements ["player in thisList", "", ""];
};

[[_position,_sound,_soundradius],_initsoundfnc] remoteExec ["call",0,true];
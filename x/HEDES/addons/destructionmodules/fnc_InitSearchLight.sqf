/*
---------------------------------------------
Destruction Module Client
Author: ZanchoElGrande

If you find this, and you think you can help me save myself. Please contact me.
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

_logic spawn {
	_this setDir random 360;
	_light = createSimpleObject ["A3\data_f\VolumeLight_searchLight.p3d", getpos _this, true];  
	_fakeanimsoldier = "C_Soldier_VR_F" createVehicle getPos _this; 
	_fakeanimsoldier allowDamage false;
	_fakeanimsoldier enableStamina false;
	hideObject _fakeanimsoldier; 
	sleep random[3,4,7];
	_fakeanimsoldier switchmove "AinvPpneMstpSrasWpstDnon_G01";
	_fakeanimsoldier setAnimSpeedCoef 0.25;
	_fakeanimsoldier attachTo [_this,[0,0,0]]; 
	_fakeanimsoldier disableAI "ALL"; 
	_fakeanimsoldier enableAI "ANIM";  
	_light attachTo [_fakeanimsoldier,[0,0,0],"head",true]; 

	_fakeanimsoldier enableDynamicSimulation true;
	_light enableDynamicSimulation true;
};



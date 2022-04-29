/*
---------------------------------------------
Destruction Module Client
Author: ZanchoElGrande

---------------------------------------------
*/

#include "script_component.hpp"

params ["_areaarr", "_fireposlist", ["_canfiredamage", false],["_smokedamage",0],["_firedamage", 0], ["_id", nil]];

{
	private _ps1 = "#particlesource" createVehicleLocal _x;
	_ps1 setParticleParams [
		["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 7, 16, 1], "", "Billboard",
		1, 8, [0, 0, 0], [0, 0, 1.5], 0, 10, 7.9, 0.066, [1, 3, 6],
		[[0.2, 0.2, 0.2, 0], [0.2, 0.2, 0.2, 0.45], [0.2, 0.2, 0.2, 0.45], [0.35, 0.35, 0.35, 0.225], [0.5, 0.5, 0.5, 0]],
		[0.25], 1, 0, "", "", _ps1];
	_ps1 setParticleRandom [0, [0.25, 0.25, 0], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
	_ps1 setDropInterval 0.1;

	private _ps2 = "#particlesource" createVehicleLocal _x;
	_ps2 setParticleParams [
		["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 10, 32], "", "Billboard",
		0, 1, [0, 0, 0.25], [0, 0, 0.5], 1, 1, 0.9, 0.3, [1.5],
		[[1,1,1, 0.0], [1,1,1, 0.3], [1,1,1, 0.0]],
		[0.75], 0, 0, "", "", _ps2, rad -45];
	_ps2 setParticleRandom [0.2, [1, 1, 0], [0.5, 0.5, 0], 0, 0.5, [0, 0, 0, 0], 0, 0];
	_ps2 setDropInterval 0.03;

	private _lightpoint = "#lightpoint" createVehicleLocal _x; 
	_lightpoint setLightColor [1,.75,.2]; 
	_lightpoint setLightBrightness .6;
	_lightpoint setLightDayLight false;
	_lightpoint setLightAttenuation [0,0,0,1];
	_lightpoint setLightAmbient [0.15,0.05,0];

} foreach _fireposlist;

HEDES_fnc_MoveSmoke = {
	params["_id","_positions"];
	
	private _objsid = format["%1_OBJS",_id];

	if (isNil _objsid) then 
	{
		missionNamespace setVariable [_objsid,[]];
	};

	{deleteVehicle _x;} foreach (missionNamespace getVariable _objsid);

	private _objlist = (missionNamespace getVariable _objsid);
	{
		if (player distance2D _x < viewDistance) then
		{
			_smoke = "#particlesource" createVehicleLocal _x;
			_smoke setParticleClass "HouseDestrSmokeLong";
			_objlist pushBack _smoke;
		};
	} foreach _positions;
};


_areaarr spawn {
	private _obj = _this # 0;
	private _areaarr = _this;
	
	while {_obj isNotEqualTo objNull} do 
	{
		if((player distance2D _obj) < dynamicSimulationDistance "GROUP") then 
		{
			private _lamps = nearestObjects [_obj, ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F"], 200]; 
			_lamps = _lamps inAreaArray _areaarr;

			{ 
				[_x, true] call BIS_fnc_switchLamp; 
			} foreach _lamps select {random 1 < .25};

			sleep .05;

			{ 
				[_x, false] call BIS_fnc_switchLamp; 
			} foreach _lamps select {random 1 < .5};
		};

		sleep random [.1,.2,5];
	};
};
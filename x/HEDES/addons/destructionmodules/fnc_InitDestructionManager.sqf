/*
---------------------------------------------
Destruction Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

_logic spawn {


trig1 spawn {

	_trg = _this;
	_radius = (_trg call HEDES_fnc_findhypotenuse)/2; 

	_list = nearestObjects [_trg, ["House", "Building"], _radius];
	_list = _list inAreaArray _trg;

	_weightruin = .25;
	_weightalivefire = .5;
	_weightruinsfire = .5;
	_weightfirepos = .15;
	_weightlargesmoke = .1;
	_smokeupdate = 10;

	_cansmokedamage = false;
	_canfiredamage = false;
	_smokedamage = .1;
	_firedamage = .1;

	_alive = [];
	_ruins = [];
	_smallfireposlist = [];
	_bigfireposlist = [];
	_largesmokelist = [];

	// -- Split buildings & create ruins.
	{
		_blg = _x;
		_blgposlist = _blg buildingPos -1;

		if (count _blgposlist > 4) then 
		{
			_x allowDamage false; 
			_x enableSimulationGlobal false;

			if (random 1 < _weightruin) then
			{
				_x setDamage [1, false];
				_ruins pushBack _x;
			} else {
				_alive pushBack _x;
			};
		};		
	} forEach _list;

	// -- Create random fire positions.
	{
		_blg = _x;
		_blgposlist = _blg buildingPos -1;

		if (count _blgposlist > 4) then 
		{
			_blgposlist = _blgposlist select {random 1 < _weightfirepos};
			{_smallfireposlist pushBack _x} forEach _blgposlist;

			_blghitpoints = (configFile >> "cfgVehicles" >> (typeof _x) >> "HitPoints") call BIS_fnc_getCfgSubClasses;
			{_blg setHit [_x, 1];} forEach (_blghitpoints select { random 1 < _weightfirepos});
		};
	} forEach (_alive select {random 1 < _weightalivefire});

	// -- Create random fire positions.
	{
		_smallfireposlist pushBack (getPos _x);
	} forEach (_ruins select {random 1 < _weightruinsfire});

	// -- Create Fire
	{
		private _ps0 = "#particlesource" createVehicleLocal _x;
		_ps0 setParticleParams [
			["\A3\Data_F\ParticleEffects\Universal\Refract", 16, 10, 32], "", "Billboard",
			0, 1, [0, 0, 0.25], [0, 0, 0.5], 1, 1, 0.9, 0.3, [1.5],
			[[1,1,1, 0.0], [1,1,1, 0.3], [1,1,1, 0.0]],
			[0.75], 0, 0, "", "", _ps0, rad -45];
		_ps0 setParticleRandom [0.2, [1, 1, 0], [0.5, 0.5, 0], 0, 0.5, [0, 0, 0, 0], 0, 0];
		_ps0 setDropInterval 0.03;

		private _ps1 = "#particlesource" createVehicleLocal _x;
		_ps1 setParticleParams [
			["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 7, 16, 1], "", "Billboard",
			1, 8, [0, 0, 0], [0, 0, 1.5], 0, 10, 7.9, 0.066, [1, 3, 6],
			[[0.2, 0.2, 0.2, 0], [0.2, 0.2, 0.2, 0.45], [0.2, 0.2, 0.2, 0.45], [0.35, 0.35, 0.35, 0.225], [0.5, 0.5, 0.5, 0]],
			[0.25], 1, 0, "", "", _ps1];
		_ps1 setParticleRandom [0, [0.25, 0.25, 0], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
		_ps1 setDropInterval 0.1;

		private _ps2 = "#particlesource" createVehicleLocal _x;
		if _canfiredamage then {_ps3 setParticleFire [_firedamage,5.0,2];};
		_ps2 setParticleParams [
			["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 10, 32], "", "Billboard",
			0, 1, [0, 0, 0.25], [0, 0, 0.5], 1, 1, 0.9, 0.3, [1.5],
			[[1,1,1, 0.0], [1,1,1, 0.3], [1,1,1, 0.0]],
			[0.75], 0, 0, "", "", _ps0, rad -45];
		_ps2 setParticleRandom [0.2, [1, 1, 0], [0.5, 0.5, 0], 0, 0.5, [0, 0, 0, 0], 0, 0];
		_ps2 setDropInterval 0.03;

		_lightpoint = "#lightpoint" createVehicleLocal getPos _ps0; 
		_lightpoint setLightColor [1,.75,.2]; 
		_lightpoint setLightBrightness .6;
		_lightpoint setLightDayLight false;
		_lightpoint setLightAttenuation [0,0,0,1];
		_lightpoint setLightAmbient [0.15,0.05,0];

		if (random 1 < _weightlargesmoke) then 
		{
			_ps4 = "#particlesource" createVehicle _x;
			_ps4 setParticleClass "HouseDestrSmokeLong";
			_largesmokelist pushBack _ps4;

			if _cansmokedamage then 
			{
				_ps4 setParticleFire [_smokedamage,30,5];
			};			
		};

	} forEach _smallfireposlist;

	[_largesmokelist,_smallfireposlist, _smokeupdate] spawn {
		while {true} do 
		{
			{
				_x setPos (selectRandom (_this # 1));
			} forEach (_this # 0);

			sleep (_this # 2);
		};
	};

	// -- Randomly Flicker Lights For Units In Range
	_this spawn {
		while {_this isNotEqualTo objNull} do 
		{
			private _lampsIn200m = nearestObjects [_this, ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F"], 200]; 

			if(allplayers findIf {_x distance2D _this < dynamicSimulationDistance "GROUP"} > -1) then 
			{
				private _code = {
					
					{ [_x, true] call BIS_fnc_switchLamp; } forEach _this select {random 1 < .25};
					sleep .15;
					{ [_x, false] call BIS_fnc_switchLamp; } forEach _this;
				};
				private _inrange = allplayers select {_x distance2D _this < dynamicSimulationDistance "GROUP"};
				[_lampsIn200m, _code] remoteExec ["spawn", _inrange];
			};

			sleep random 5;
		};
	};
};
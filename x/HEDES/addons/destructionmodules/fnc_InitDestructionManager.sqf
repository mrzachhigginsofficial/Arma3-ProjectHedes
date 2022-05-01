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

	private _id = ["AMBIENTDESTRUCTIONPARAMS"] call FUNCMAIN(GenerateUID);
	
	private _areaarr = [getpos _this] + (_this getVariable "ObjectArea");
	private _radius = (_this call HEDES_fnc_findhypotenuse)/2; 
	private _alive = [];
	private _ruins = [];
	private _list = nearestObjects [_this, ["House", "Building"], _radius];
	_list = _list inAreaArray _areaarr;


	private _weightruin =  _this getVariable ["RuinWeight",.25];
	private _weightalivefire = _this getVariable ["AliveFireWeight",.5];
	private _weightruinsfire = _this getVariable ["RuinsFireWeight",.5];
	private _weightfirepos = _this getVariable ["AliveFirePositionWeight",.15];
	private _weightlargesmoke =  _this getVariable ["LargeSmokeWeight",.1];
	private _flickerlights = _this getVariable ["FlickerLocalLightsOnClient", true];

	private _smokeupdateinterval = _this getVariable ["SmokeUpdateInterval",25];
	private _cansmokedamage = false;
	private _canfiredamage = false;
	private _smokedamage = .1;
	private _firedamage = .1;

	private _fireposlist = [];

	// Split buildings & create ruins.
	{
		_blg = _x;
		_blgposlist = _blg buildingPos -1;

		if (count _blgposlist > 4) then 
		{
			if (random 1 < _weightruin) then
			{
				_blg setDamage [1, false];
				_ruins pushBack _blg;
			} else {
				_blghitpoints = (configFile >> "cfgVehicles" >> (typeof _x) >> "HitPoints") call BIS_fnc_getCfgSubClasses;
				if (count _blghitpoints > 4) then 
				{
					{_blg setHit [_x, 1];} forEach (_blghitpoints select { random 1 < _weightfirepos});
				};
				_alive pushBack _blg;
			};

			_blg allowDamage false; 
			_blg enableSimulationGlobal false;
		};		
	} foreach _list;

	// Create random fire positions.
	{
		_blg = _x;
		_blgposlist = _blg buildingPos -1;

		if (count _blgposlist > 4) then 
		{
			_blgposlist = _blgposlist select {random 1 < _weightfirepos};
			{_fireposlist pushBack _x} forEach _blgposlist;
		};
	} foreach (_alive select {random 1 < _weightalivefire});

	// Create random fire positions.
	{
		_fireposlist pushBack (getPos _x);
	} foreach (_ruins select {random 1 < _weightruinsfire});	

	// Broadcast update to clients.
	private _emitters = [_areaarr, _fireposlist, _canfiredamage, _smokedamage, _firedamage, _id, _flickerlights];
	_emitters remoteExec [QUOTE(FUNCMAIN(InitDestructionClient)),0,true];

	// Spawn thread to periodically move large smoke clouds.
	[_this, _id, _fireposlist, _weightlargesmoke, _smokeupdateinterval] spawn 
	{
		params ["_this", "_id", "_fireposlist", "_weightlargesmoke","_smokeupdateinterval"];

		while {_this isNotEqualTo objNull} do 
		{
			_newpositions = [];
			{
				_newpositions pushBack _x
			} foreach (_fireposlist select {random 1 < _weightlargesmoke});

			[_id, _newpositions] remoteExec [QUOTE(FUNCMAIN(MoveSmoke)), 0, false];

			sleep random [_smokeupdateinterval, _smokeupdateinterval * 1.8, _smokeupdateinterval * 2];
		};
	};
};
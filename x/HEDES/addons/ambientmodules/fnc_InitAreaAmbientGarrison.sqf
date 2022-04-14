/*
---------------------------------------------
Initialized Ambient Garrison Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];

/*
--------------------------------------------------------------------
Main Thread
--------------------------------------------------------------------
*/

_logic spawn {	
	// -- Initialize Variables
	private _spawnpos = [0,0,0];
	private _triggeri = objNull;
	private _grpi = grpNull;
	private _sector = objNull;
	private _sectorside = sideUnknown;
	private _i = 0;
	private _maxtry = 5;
	private _wpname = QUOTE(HEDES_GARRISON);

	// -- Get Module Properties
	private _unitpool = call compile (_this getVariable ["UnitPool",[]]);
	private _maxunits = call compile (_this getVariable ["NumbersofUnits",5]);
	private _defaultside = call compile (_this getVariable ["GarrisonSide",EAST]);
	private _behavior = _this getVariable "UnitBehavior";
	private _areatriggers = synchronizedObjects _this select {_x isKindOf "EmptyDetector"} apply {[_x,grpNull]};
	private _sectors = synchronizedObjects _this select { typeOf _x == "ModuleSector_F" };

	// -- Initialize Default Trigger Area	
	if (count(_areatriggers) == 0) then 
	{
		private _newtrigger = createtrigger ["emptydetector", position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger attachto [_this];
		_areatriggers pushBack [_newtrigger,grpNull];
	};

	// -- Configure Unit Behavior 
	private _behaviorfnc = {};
	switch (_behavior) do {
		case QUOTE(CBA - Defend): {
			_behaviorfnc = {(_this # 0) call CBA_fnc_taskDefend;}
		};
		case QUOTE(CBA - Patrol): {
			_behaviorfnc = {[(_this # 0), getPos (_this # 1)] call CBA_fnc_taskPatrol;}
		};
		case QUOTE(CBA - Waypoint Garrison): {
			_behaviorfnc = {[(_this # 0), getPos (_this # 1)] execVM QUOTE(\x\cba\addons\ai\fnc_waypointGarrison.sqf);}
		};
		case QUOTE(BIS - Defend): {
			_behaviorfnc = {[(_this # 0), getPosATL (_this # 1)] call BIS_fnc_taskDefend;}
		};
		case QUOTE(BIS - Patrol): {
			_behaviorfnc = {[(_this # 0), getPos (_this # 1), 30] call BIS_fnc_taskPatrol;}
		};
		default { };
	};
	
	// -- Main Loop
	while { _this isNotEqualTo objNull } do 
	{
		if (simulationEnabled _this) then
		{
			// -- Iterate Through Each Trigger Area
			{
				_triggeri = _x # 0;
				_grpi = _x # 1;
				_spawnpos = _triggeri call BIS_fnc_randomPosTrigger;

				// -- Do if there are Synchronized Sector Control Modules (For Sector Control)
				if ((count _sectors) > 0) then 
				{
					_sector = _sectors # 0;
					while {isNil {_sector getVariable "owner"}} do {sleep 2};
					_sectorside = _sector getVariable "owner";		

					// -- Check To See If Sector Control Module Side Matches Garrison Group Side
					// -- If group doesn't exist or side is not the same, create a new group.
					if ((_sectorside isNotEqualTo (side _grpi)) or (_grpi isEqualTo grpNull)) then 
					{
						if !(_sectorside == sideUnknown) then 
						{ 
							_grpi = [_spawnpos, _sectorside, _maxunits] call BIS_fnc_spawnGroup;
							[_grpi] spawn FUNCMAIN(DynamicSimulation);
							(units _grpi) apply {_x call FUNCMAIN(AppendCleanupSystemObjects)};
							_x set [1,_grpi];
						};				
					};

					// -- Spawn new units if the following conditions are met...
					if !([_this, (side _grpi)] call FUNCMAIN(IsEnemyPlayersNear)) then
					{
						_i = 0;
						while {!([_grpi,_maxunits] call FUNCMAIN(IsGroupFull)) && _i < _maxtry} do	
						{
							private _unitcount = _maxunits - count(units _grpi);
							private _newgrp = [_spawnpos, (side _grpi), _unitcount] call BIS_fnc_spawnGroup;
							(units _newgrp) apply { _x call FUNCMAIN(AppendCleanupSystemObjects)};
							(units _newgrp) joinSilent _grpi;

							_i = _i + 1;
						};

						// -- Reset Group Behavior
						[_grpi, _triggeri] call _behaviorfnc;
					};
				}

				// -- Do if there are NO Synchronized Sector Control Modules
				else 
				{
					// -- Create Group If It's Destroyed Or Doesn't Exist Yet.
					if (_grpi isEqualTo grpNull) then 
					{
						_grpi = createGroup [_defaultside, true];
						[_grpi] spawn FUNCMAIN(DynamicSimulation);
						_x set [1,_grpi];						
					};

					if (!([_this, _defaultside] call FUNCMAIN(IsEnemyPlayersNear))) then 
					{
						_i = 0;
						while {!([_grpi,_maxunits] call FUNCMAIN(IsGroupFull)) && _i < _maxtry} do
						{
							private _unit = _grpi createUnit [selectRandom _unitpool,_spawnpos,[],0,"FORM"];
							_unit call FUNCMAIN(AppendCleanupSystemObjects);

							 _i = _i + 1;
						};
					};

					// -- Reset Group Behavior
					[_grpi, _triggeri] call _behaviorfnc;
				};

				// -- Keep Patrols Moving
				if(QUOTE(Patrol) in _behavior && count(waypoints _grpi) < 2) then {
					[_grpi, _triggeri] call _behaviorfnc;
				};

			} foreach _areatriggers;

			// -- Go to sleep for a bit.
			sleep 15;
		};
	};
};
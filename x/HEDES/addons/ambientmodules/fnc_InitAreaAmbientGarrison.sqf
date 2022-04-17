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
	private _maxunits = _this getVariable ["NumbersofUnits",5];
	private _simdelay = _this getVariable ["SimulationDelay",15];
	private _defaultside = call compile (_this getVariable ["GarrisonSide",EAST]);
	private _behaviour = _this getVariable "UnitCombatBehaviour";
	private _combattask = _this getVariable "UnitCombatTask";
	private _speedmode = _this getVariable "SpeedMode";
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
	private _combattaskfnc = {};
	switch (_combattask) do {
		case QUOTE(CBA - Defend): {
			_combattaskfnc = {(_this # 0) call CBA_fnc_taskDefend;}
		};
		case QUOTE(CBA - Patrol): {
			_combattaskfnc = {[(_this # 0), getPos (_this # 1)] call CBA_fnc_taskPatrol;}
		};
		case QUOTE(CBA - Waypoint Garrison): {
			_combattaskfnc = {[(_this # 0), getPos (_this # 1)] execVM QUOTE(\x\cba\addons\ai\fnc_waypointGarrison.sqf);}
		};
		case QUOTE(BIS - Defend): {
			_combattaskfnc = {[(_this # 0), getPosATL (_this # 1)] call BIS_fnc_taskDefend;}
		};
		case QUOTE(BIS - Patrol): {
			_combattaskfnc = {[(_this # 0), getPos (_this # 1), triggerArea (_this # 1) select 0] call BIS_fnc_taskPatrol;}
		};
		default { };
	};

	// -- Unit Spawning and Side Switching Function 
	private _spawnnewunits = {
		params["_pvtgrp","_pvtmaxunits","_pvtspawnpos",["_pvtspawncustom", false],["_pvtunitpool",[]]];
		private _pvti = 0;
		while {!([_pvtgrp,_pvtmaxunits] call FUNCMAIN(IsGroupFull)) && _pvti < _pvtmaxunits * 2} do	
		{
			try
			{
				if (_pvtspawncustom) then 
				{
					private _unit = _pvtgrp createUnit [selectRandom _pvtunitpool,_pvtspawnpos,[],0,"FORM"];
					_unit setPosATL [(getPosATL _unit) # 0, (getPosATL _unit) # 1 ,0];
					_unit call FUNCMAIN(AppendCleanupSystemObjects);
					_unit setBehaviour _behaviour;
				} else {
					private _unitcount = _pvtmaxunits - count(units _pvtgrp);
					private _newgrp = [_spawnpos, side _pvtgrp, _unitcount] call BIS_fnc_spawnGroup;
					(units _newgrp) apply {_x setBehaviour _behaviour};
					(units _newgrp) apply { _x setPosATL [(getPosATL _x) # 0, (getPosATL _x) # 1 ,0] };
					(units _newgrp) apply { _x call FUNCMAIN(AppendCleanupSystemObjects) };
					(units _newgrp) joinSilent _pvtgrp;
				};
			}
			catch 
			{
				_exception call BIS_fnc_log;
			};
			
			_pvti = _pvti + 1;
		};
	};
	
	// -- Main Loop
	while { _this isNotEqualTo objNull } do 
	{
		if (simulationEnabled _this) then
		{
			// -- Iterate Over Each Trigger Area
			{
				_triggeri = _x # 0;
				_grpi = _x # 1;

				_spawnpos = [_triggeri, false, 5] call FUNCMAIN(FindHiddenRanPosInMarker);
                if (_spawnpos isNotEqualTo [0,0]) then 
				{
					// -- Do if there are Synchronized Sector Control Modules (For Sector Control)
					if ((count _sectors) > 0) then 
					{
						_sector = _sectors # 0;
						while {isNil {_sector getVariable "owner"}} do {sleep 2};
						_sectorside = _sector getVariable "owner";		
						if (_sectorside == sideUnknown) then {_sectorside = _defaultside};

						// -- Check To See If Sector Control Module Side Matches Garrison Group Side
						// -- If group doesn't exist or side is not the same, create a new group.
						if ((_sectorside isNotEqualTo (side _grpi)) or (_grpi isEqualTo grpNull)) then 
						{
							_grpi = createGroup [_sectorside, true];
							_grpi setSpeedMode _speedmode;
							[_grpi] spawn FUNCMAIN(DynamicSimulation);
							_x set [1,_grpi];				
						};

						// -- Spawn New Units & Reset Group Behavior
						if (!([_this, side _grpi] call FUNCMAIN(IsEnemyPlayersNear))) then 
						{
							[_grpi, _maxunits, _spawnpos] call _spawnnewunits;
							[_grpi, _triggeri] call _combattaskfnc;
						};
					}

					// -- Do if there are NO Synchronized Sector Control Modules
					else 
					{
						// -- Create Group If It's Destroyed Or Doesn't Exist Yet.
						if (_grpi isEqualTo grpNull) then 
						{
							_grpi = createGroup [_defaultside, true];
							_grpi setSpeedMode _speedmode;
							[_grpi,nil,nil,_simdelay] spawn FUNCMAIN(DynamicSimulation);
							_x set [1,_grpi];						
						};

						// -- Spawn New Units & Reset Group Behavior
						if (!([_this, _defaultside] call FUNCMAIN(IsEnemyPlayersNear))) then 
						{
							[_grpi, _maxunits, _spawnpos, true, _unitpool] call _spawnnewunits;
							[_grpi, _triggeri] call _combattaskfnc;
						};
					};
				};

				// -- Keep Patrols Moving
				if(QUOTE(Patrol) in _combattask && count(waypoints _grpi) < 2) then {
					[_grpi, _triggeri] call _combattaskfnc;
				};

			} foreach _areatriggers;

			// -- Go to sleep for a bit.
			sleep 15;
		};
	};
};
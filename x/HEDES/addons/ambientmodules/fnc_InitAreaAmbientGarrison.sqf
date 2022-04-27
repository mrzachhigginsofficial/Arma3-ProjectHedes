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
	private _isfirstspawn = 1;

	// -- Get Module Properties
	private _newunitsarr = [];
	private _newunitinitfnc = compile (_this getVariable ["UnitInit", ""]);
	private _unitpool = call compile (_this getVariable ["UnitPool","[]"]);
	private _maxunits = _this getVariable ["NumbersofUnits",5];
	private _simdelay = _this getVariable ["SimulationDelay",15];
	private _defaultside = call compile (_this getVariable ["GarrisonSide","EAST"]);
	private _behaviour = _this getVariable "UnitCombatBehaviour";
	private _combattask = _this getVariable "UnitCombatTask";
	private _speedmode = _this getVariable "SpeedMode";
	private _areatriggers = synchronizedObjects _this select {_x isKindOf "EmptyDetector"} apply {[_x,grpNull,0]};
	private _sectors = synchronizedObjects _this select { typeOf _x == "ModuleSector_F" };
	private _interval = _this getVariable ["SimulationInterval",15];
	private _orderrefresh = _this getVariable ["OrderRefreshInterval",300];
	private _orderi = 0;

	// -- Initialize Default Trigger Area	
	if (count(_areatriggers) == 0) then 
	{
		private _newtrigger = createtrigger ["emptydetector", position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger setPos (getPos _this);
		_newtrigger enableSimulationGlobal false;
		_areatriggers pushBack [_newtrigger,grpNull,0];
	};

	// -- Disable Simulation on Triggers
   {
      (_x # 0) enableSimulationGlobal false;
   } foreach _areatriggers;

	// -- Configure Unit Behavior 
	private _combattaskfnc = {};
	switch (_combattask) do {
		case QUOTE(CBA - Defend): {
			_combattaskfnc = {(_this # 0) call CBA_fnc_taskDefend;}
		};
		case QUOTE(CBA - Patrol): {
			_combattaskfnc = {[(_this # 0), getPos (_this # 1), (_this # 2)] call CBA_fnc_taskPatrol;}
		};
		case QUOTE(CBA - Waypoint Garrison): {
			_combattaskfnc = {[(_this # 0), getPos (_this # 1)] execVM QUOTE(\x\cba\addons\ai\fnc_waypointGarrison.sqf);}
		};
		case QUOTE(CBA - Search Nearby): {
			_combattaskfnc = {[(_this # 0), (_this # 1)] call CBA_fnc_taskSearchArea;}
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
				private _newgrp = grpNull;
				private _unitcount = _pvtmaxunits - count(units _pvtgrp);
				if (_pvtspawncustom) then 
				{					
					private _composition = [];
					while {count _composition < _unitcount} do 
					{
						_composition pushBack (selectRandom _pvtunitpool);
					};
					_newgrp = [_spawnpos, side _pvtgrp, _composition] call BIS_fnc_spawnGroup;
				} else {
					_newgrp = [_spawnpos, side _pvtgrp, _unitcount] call BIS_fnc_spawnGroup;
				};
				_newunitsarr = (units _newgrp);
				(units _newgrp) apply { _x setBehaviour _behaviour };
				(units _newgrp) apply { _x setPosATL [(getPosATL _x) # 0, (getPosATL _x) # 1 ,0] };
				(units _newgrp) apply { _x call FUNCMAIN(AppendCleanupSystemObjects) };
				(units _newgrp) apply { _x disableAI "RADIOPROTOCOL" };
				(units _newgrp) joinSilent _pvtgrp;
				_newunitsarr apply {_x call _newunitinitfnc};
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
				_orderi = _x # 2;

				_spawnpos = if(_isfirstspawn == 1) then {
					[_triggeri call BIS_fnc_randomPosTrigger, 5, 10] call BIS_fnc_findSafePos
				} else {
					[_triggeri, false, 5] call FUNCMAIN(FindHiddenRanPosInMarker)
				};

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
						if (!([_this, side _grpi] call FUNCMAIN(IsEnemyPlayersNear)) or _isfirstspawn == 1) then 
						{
							[_grpi, _maxunits, _spawnpos] call _spawnnewunits;
							_radius = if ((triggerArea _triggeri) # 3) then 
							{
								[_triggeri] call FUNCMAIN(FindHypotenuse)
							} else 
							{
								(triggerArea _triggeri) # 0
							};
							[_grpi, _triggeri, _radius] call _combattaskfnc;
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
						if (!([_this, _defaultside] call FUNCMAIN(IsEnemyPlayersNear)) or _isfirstspawn == 1) then 
						{
							[_grpi, _maxunits, _spawnpos, true, _unitpool] call _spawnnewunits;
							[_grpi, _triggeri] call _combattaskfnc;
						};
					};
				};		 

				// -- Keep Patrols Moving
				if(
					((QUOTE(Patrol) in _combattask) or (QUOTE(Search) in _combattask)) && 
					(_orderrefresh/_interval >= _orderi)
				) then 
				{
					[_grpi] call CBA_fnc_clearWaypoints;
					[_grpi, _triggeri] call _combattaskfnc;
					_x set [2, 0];
				} else 
				{
					_x set [2, _orderi + 1];
				};

			} foreach _areatriggers;

			_isfirstspawn = 0;
		};

		// -- Go to sleep for a bit.
		sleep _interval;
	};
};
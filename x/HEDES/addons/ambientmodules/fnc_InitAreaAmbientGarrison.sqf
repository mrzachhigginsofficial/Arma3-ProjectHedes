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

	private _unitpool = [];
	private _maxunits = 0;
	private _defaultside = sideUnknown;
	private _sectors = [];
	private _grp = grpNull;
	private _i = 5;

	while { _this isNotEqualTo objNull } do {

		if(simulationEnabled _this) then
		{
			// ******************************************************************
			// Object Initialization Properties 
			// Notes: These are here incase we change the nature of these modules 
			// 		mid scenario, we won't have to create new modules.
			// ******************************************************************
			// -- Get Object Properties
			_unitpool = call compile (_this getVariable ["UnitPool",[]]);
			_maxunits = call compile (_this getVariable ["NumbersofUnits",5]);
			_defaultside = call compile (_this getVariable ["GarrisonSide",EAST]);

			// -- Get Synchronized Modules
			_sectors = (synchronizedObjects _this select { typeOf _x == "ModuleSector_F" });

			// -- Find Safespawn Every Iteration
			private _safespawnpos = [getPos _this, 25, 250, 3, 0, 20, 0] call BIS_fnc_findSafePos;
			// ******************************************************************


			// ******************************************************************
			// -- Do if there are Synchronized Sector Control Modules (For Sector Control)
			// ******************************************************************
			if ((count _sectors) > 0) then 
			{
				private _sector = _sectors # 0;
				// -- Handle Slow Sector Initialization
				while {isNil {_sector getVariable "owner"}} do {sleep 2};
				private _sectorside = _sector getVariable "owner";		

				// -- Check To See If Sector Control Module Side Matches Garrison Group Side
				// -- If group doesn't exist or side is not the same, create a new group.
				if ((_sectorside isNotEqualTo (side _grp)) or (_grp isEqualTo grpNull)) then 
				{
					if !(_sectorside == sideUnknown) then 
					{ 
						_grp = [_safespawnpos, _sectorside, _maxunits] call BIS_fnc_spawnGroup;
						_grp enableDynamicSimulation true;
						_grp deleteGroupWhenEmpty true;
						(units _grp) apply {_x call FUNCMAIN(AppendCleanupSystemObjects)};
					};				
				};

				// -- Spawn new units if the following conditions are met...
				// --	1.) Number of units in group is less than max units
				// -- 	2.) There are no enemy players (players that dont match garison side) in range
				if (!([_grp,_maxunits] call FUNCMAIN(IsGroupFull)) && !([_this, (side _grp)] call FUNCMAIN(IsEnemyPlayersNear))) then
				{
					private _newgroupunitcount = _maxunits - count(units _grp);
					private _newgrp = [_safespawnpos, (side _grp), _newgroupunitcount] call BIS_fnc_spawnGroup;
					_newgrp enableDynamicSimulation true;
					_newgrp deleteGroupWhenEmpty true;

					(units _newgrp) apply { _x call FUNCMAIN(AppendCleanupSystemObjects)};
					(units _newgrp) joinSilent _grp;

				};
			// ******************************************************************


			// ******************************************************************
			// -- Do if there are no synchronized sectors and we're doing default behavior.
			// ******************************************************************
			} else {
				// -- Create Group If It's Destroyed Or Doesn't Exist Yet.
				if (_grp isEqualTo grpNull) then 
				{
					_grp = createGroup [_defaultside, true];
					_grp enableDynamicSimulation true;
				};

				if (!([_grp,_maxunits] call FUNCMAIN(IsGroupFull)) && !([_this, _defaultside] call FUNCMAIN(IsEnemyPlayersNear))) then
				{
					private _unit = _grp createUnit [selectRandom _unitpool,_safespawnpos,[],0,"FORM"];
					_unit call FUNCMAIN(AppendCleanupSystemObjects);
				};
			};
			// ******************************************************************


			// ******************************************************************
			// -- Periodically randomly pick if this group is going to patrol or defend area.
			// -- The thread sleeps for 60 seconds, and every 5th iteration a new random task is select.
			// ******************************************************************
			if((_i%5) == 0) then {
				_i = 0;
				switch(ceil random 2) do
				{
					case 1: {[_this, _grp, 50] call CBA_fnc_taskPatrol};
					default {_grp call CBA_fnc_taskDefend};
				};
			} else {
				_i = _i + 1;
			};
			// ******************************************************************
			

			// -- Go to sleep for a bit.
			sleep 60;
		};
	};
};
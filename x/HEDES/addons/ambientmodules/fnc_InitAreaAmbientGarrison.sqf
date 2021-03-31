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
	private _unitpool = call compile (_this getVariable ["UnitPool",[]]);
	private _maxunits = call compile (_this getVariable ["NumbersofUnits",5]);
	private _side = call compile (_this getVariable ["GarrisonSide","EAST"]);
	private _grp = createGroup [_side, false];

	while { true } do {

		// -- Refill Unit Pool 
		if (
			(count((units _grp) select {alive _x})) < _maxunits &&
			count(_this nearEntities ["Man",200] select {_x in allPlayers}) == 0
		) then{
			private _safespawnpos = [getPos _this, 25, 250, 3, 0, 20, 0] call BIS_fnc_findSafePos;
			private _unit = _grp createUnit [selectRandom _unitpool,_safespawnpos,[],0,"FORM"];
			_unit enableDynamicSimulation true;
		};

		switch(ceil random 2) do
		{
			case 1: {[_this, _grp, 50] call CBA_fnc_taskPatrol};
			default {_grp call CBA_fnc_taskDefend};
		};

		sleep 300;
	};
};
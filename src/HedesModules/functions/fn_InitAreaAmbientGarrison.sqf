/*
--------------------------------------------------------------------
Initialize Ambient Civilians Module.

Description:
	Creates Ambients Civs that can sometimes run in fear or kill you.

Notes:
	None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "..\macros.h"
#include "..\defines.h"

private _logic = param [0, objNull, [objNull]];
private _unitpool = _logic getVariable ["UnitPool",[]];
private _maxunits = _logic getVariable ["NumbersofUnits",5];
private _side = call compile (_logic getVariable ["GarrisonSide",true]);

private _grp = createGroup [_side, false];

/*
--------------------------------------------------------------------
Main Thread
--------------------------------------------------------------------
*/
while { true } do {

    // -- Refill Unit Pool 
	if (
        (count((units _grp) select {alive _x})) < (call compile _maxunits) &&
        count(_logic nearEntities ["Man",200] select {_x in allPlayers}) == 0
    ) then{
		private _safespawnpos = [getPos _logic, 25, 250, 3, 0, 20, 0] call BIS_fnc_findSafePos;
		private _unit = _grp createUnit [selectRandom (call compile _unitpool),_safespawnpos,[],0,"FORM"];
        _unit enableDynamicSimulation true;
	};

	_grp call CBA_fnc_taskDefend;

	sleep 15;
};
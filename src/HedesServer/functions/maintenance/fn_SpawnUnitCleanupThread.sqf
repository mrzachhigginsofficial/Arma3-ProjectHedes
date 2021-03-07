/*
--------------------------------------------------------------------
Unit Cleanup Thread.

Description:
	A simple processes that removes units no longer required in the 
	simulation.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

if (!isServer) exitWith {};

if (isnil GLOABLMISSIONCLEANUPQUEUE) then {
    missionNamespace setVariable [GLOABLMISSIONCLEANUPQUEUE, []];
};

while {true} do {
	{
		if { count(_x nearEntities ["Man",300] select {_x in allPlayers}) > 0 } then
		{
			deleteVehicle _x;
		};
		sleep 1;
	} foreach (missionNamespace getVariable GLOABLMISSIONCLEANUPQUEUE);

	private _updatedvar = missionNamespace getVariable GLOABLMISSIONCLEANUPQUEUE;
	missionNamespace setVariable [GLOABLMISSIONCLEANUPQUEUE, _updatedvar - [objNull]];

	sleep 5;
};
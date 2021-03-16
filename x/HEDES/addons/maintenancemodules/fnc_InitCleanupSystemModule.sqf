/*
---------------------------------------------
Init Unit Cleanup Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

ISNILS(GVAR(GLOBALCLEANUPLIST),[]);

while {true} do {
	{
		if ( count(_x nearEntities ["Man",300] select {_x in allPlayers}) > 0 ) then
		{
			deleteVehicle _x;
		};
		sleep 1;
	} foreach (missionNamespace getVariable GVAR(GLOBALCLEANUPLIST );

	private _updatedvar = missionNamespace getVariable GVAR(GLOBALCLEANUPLIST ;
	missionNamespace setVariable [ GVAR(GLOBALCLEANUPLIST , _updatedvar - [objNull]];

	sleep 5;
};
/*
---------------------------------------------
Init Unit Cleanup Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

ISNILS(GVARMAIN(GLOBALCLEANUPLIST),[]);

[] spawn {
	while {true} do {
		{
			if ( count(_x nearEntities ["Man",300] select {_x in allPlayers}) == 0 ) then
			{
				deleteVehicle _x;
			};
			sleep 1;
		} foreach ( missionNamespace getVariable QGVARMAIN(GLOBALCLEANUPLIST) );

		missionNamespace setVariable [ QGVARMAIN(GLOBALCLEANUPLIST) , GVARMAIN(GLOBALCLEANUPLIST) - [objNull] ];

		sleep 5;
	};
};
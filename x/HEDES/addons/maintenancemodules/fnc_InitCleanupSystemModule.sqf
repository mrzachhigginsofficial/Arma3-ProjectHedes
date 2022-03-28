/*
---------------------------------------------
Init Unit Cleanup Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];
private _timeout = parseNumber (_logic getVariable ["LifeSpanValue",""]);

ISNILS(GVARMAIN(GLOBALCLEANUPLIST),[]);

[_timeout] spawn {
	private _timeout = _this select 0;
	while {true} do {
		{
			// See if anyone can see this unit before deleting it.
			private _candidate = _x select 0;
			private _nearplayers = _candidate nearEntities ["Man",500] select {_x in allPlayers};
			private _visibletocount = count(_nearplayers select {[objNull, "VIEW"] checkVisibility [eyePos player, eyePos _x] > .2});

			if (_visibletocount == 0) then
			{
				deleteVehicle _candidate;
			};

			sleep 1;
			
		} foreach ( missionNamespace getVariable QGVARMAIN(GLOBALCLEANUPLIST) select {
			(_x select 1) + _timeout < time
		} );

		missionNamespace setVariable [ QGVARMAIN(GLOBALCLEANUPLIST), GVARMAIN(GLOBALCLEANUPLIST) select {_x select 0 != objNull} ];

		sleep 5;
	};
};
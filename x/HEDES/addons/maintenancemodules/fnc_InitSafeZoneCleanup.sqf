/*
---------------------------------------------
Init SafeZone Unit Cleanup Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};


private _logic = param [0, objNull, [objNull]];

_logic spawn {

	private _marker = _this getVariable "SafeZoneMarkerName";

	while {true} do {

	 	allUnits select {
				!(_x in allPlayers)
			} select {
				!(_x inArea _marker)
			} select {
				count(_x nearEntities ["Man",200] select {_x in allPlayers}) == 0
			} apply {deleteVehicle _x};

		sleep 15;
		
	};
};
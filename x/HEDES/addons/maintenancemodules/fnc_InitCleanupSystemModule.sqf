/*
---------------------------------------------
Init Unit Cleanup Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

ISNILS(GVARMAIN(GLOBALCLEANUPLIST),[]);

_logic spawn {

	while {_this isNotEqualTo objNull} do 
	{

		if(simulationEnabled _this)
		{
			
			private _timeout = parseNumber (_this getVariable ["LifeSpanValue",""]);
			private _candidate = objNull;
			private _nearplayers = [];
			private _visibletocount = 0;

			{
				// See if anyone can see this unit before deleting it.
				_candidate = _x select 0;
				_nearplayers = allPlayers select {(_x distance _candidate) < dynamicSimulationDistance "GROUP"};

				if((count _nearplayers) > 0) then {

					_visibletocount = count(_nearplayers select {[objNull, "VIEW"] checkVisibility [eyePos player, eyePos _x] > .2});
					if (_visibletocount == 0) then
					{
						deleteVehicle _candidate;
					};
				};

				sleep 1;

			} foreach ( missionNamespace getVariable QGVARMAIN(GLOBALCLEANUPLIST) select {(_x select 1) + _timeout < time} );

			missionNamespace setVariable [ QGVARMAIN(GLOBALCLEANUPLIST), GVARMAIN(GLOBALCLEANUPLIST) select {_x select 0 isNotEqualTo objNull} ];

			sleep 1;
		};
	};
};
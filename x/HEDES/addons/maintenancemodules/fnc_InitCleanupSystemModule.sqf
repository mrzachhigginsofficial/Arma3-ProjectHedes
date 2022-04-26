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

	private _timeout = 0;
	private _candidate = objNull;
	private _nearplayers = [];
	private _visibletocount = 0;


	while {_this isNotEqualTo objNull} do 
	{
		if(simulationEnabled _this) then
		{			
			private _timeout = _this getVariable ["LifeSpanValue",240];
			private _interval = _this getVariable ["SimulationInterval",240];

			{
				// See if anyone can see this unit before deleting it.
				_candidate = _x select 0;
				_nearplayers = allPlayers select {(_x distance _candidate) < dynamicSimulationDistance "GROUP"};

				if((count _nearplayers) == 0) then {

					_visibletocount = _nearplayers findIf {[objNull, "VIEW"] checkVisibility [eyePos _candidate, eyePos _x];
					if (_visibletocount isEqualTo -1) then
					{
						deleteVehicle _candidate;
					};
				};
			} foreach ( missionNamespace getVariable QGVARMAIN(GLOBALCLEANUPLIST) select {(_x select 1) + _timeout < time} );

			missionNamespace setVariable [ QGVARMAIN(GLOBALCLEANUPLIST), GVARMAIN(GLOBALCLEANUPLIST) select {_x select 0 isNotEqualTo objNull} ];
		};

		sleep _interval;
	};
};
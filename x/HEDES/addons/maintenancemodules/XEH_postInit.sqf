#include "script_component.hpp"

if (!isServer) exitWith {};


[] spawn {

	private _timeout = 0;
	private _candidate = objNull;
	private _nearplayers = [];
	private _visibletocount = 0;

	ISNILS(GVARMAIN(MAINTENANCE_TIMEOUT),240);
	ISNILS(GVARMAIN(MAINTENANCE_INTERVAL),30);
	ISNILS(GVARMAIN(GLOBALCLEANUPLIST),[]);

	while {true} do 
	{
		{
			// See if anyone can see this unit before deleting it.
			_candidate = _x select 0;
			_nearplayers = allPlayers findIf {(_x distance2D leader _candidate) < dynamicSimulationDistance "GROUP"};

			if(_nearplayers isEqualTo -1) then 
			{
				switch (typeName _candidate) do {
					case "GROUP": { 
						{
							deleteVehicle _x;
						} foreach (units _candidate);
					};
					default { 
						deleteVehicle _candidate; 
					};
				};				
			};
		} foreach ( missionNamespace getVariable QGVARMAIN(GLOBALCLEANUPLIST) select {(_x select 1) + GVARMAIN(MAINTENANCE_TIMEOUT) < time} );

		missionNamespace setVariable [ QGVARMAIN(GLOBALCLEANUPLIST), GVARMAIN(GLOBALCLEANUPLIST) select {_x select 0 isNotEqualTo objNull} ];

		sleep GVARMAIN(MAINTENANCE_INTERVAL);
	};
};
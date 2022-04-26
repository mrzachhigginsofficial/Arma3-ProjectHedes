/*
---------------------------------------------
Draw Friendly Name Plates
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

ISNILS(GVAR(DRAWFRIENDLYNAMEPLAYERS),[]);

GVAR(DRAWFRIENDLYNAMECOLORS) = [
	[0.73, 0.24, 0.11, 1], 		//Orange (Good Contrast)
	[1, 1, 1, 1], 				//White
	[0, 1, 0, 1]  				//Green
];

[] spawn { 
	// Custom Event Heandler
	_namePlateEH = addMissionEventHandler ["Draw3D", { 

		_color = GVAR(DRAWFRIENDLYNAMECOLORS) select 2;

		{
			// Set Nameplate Color
			if(_x in (units group player)) then
			{
				_color = GVAR(DRAWFRIENDLYNAMECOLORS) select 1;
			};

			drawIcon3D ["", _color, visiblePosition _x vectorAdd [0, 0, 2], 0.6, 0.6, 45, format ["%1", name _x], 1, 0.04, "PuristaSemiBold","",true]; 
		} forEach GVAR(DRAWFRIENDLYNAMEPLAYERS); 
	}];

	// Updates Units To ID
	while {true} do { 

		if (player isNotEqualTo objNull) then 
		{
			GVAR(DRAWFRIENDLYNAMEPLAYERS) = player nearEntities["Man", 20] select { 
				side _x == side player && _x != player
			}; 
		};

		sleep 1; 
	}; 

	// Remove Mission EH
	removeMissionEventHandler ["Draw3D",_namePlateEH];
}; 
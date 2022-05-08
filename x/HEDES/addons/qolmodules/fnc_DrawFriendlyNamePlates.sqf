/*
---------------------------------------------
Draw Friendly Name Plates
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"



_initplatersfnc = { 
	[] spawn 
	{
		HEDES_DRAWFRIENDLYNAMEPLAYERS = [];
		HEDES_DRAWFRIENDLYNAMECOLORS = [[0.73, 0.24, 0.11, 1], [1, 1, 1, 1],[0, 1, 0, 1]];

		_namePlateEH = addMissionEventHandler ["Draw3D", 
		{ 
			_color = HEDES_DRAWFRIENDLYNAMECOLORS select 2;
			{
				if(_x in (units group player)) then
				{
					_color = HEDES_DRAWFRIENDLYNAMECOLORS select 1;
				};

				drawIcon3D ["", _color, visiblePosition _x vectorAdd [0, 0, 2], 0.6, 0.6, 45, format ["%1", name _x], 1, 0.04, "PuristaSemiBold","",true]; 
			} forEach HEDES_DRAWFRIENDLYNAMEPLAYERS; 
		}];

		while {true} do 
		{ 
			if (player isNotEqualTo objNull) then 
			{
				HEDES_DRAWFRIENDLYNAMEPLAYERS = player nearEntities["Man", 20] select { 
					side _x == side player && _x != player
				}; 
			};
			sleep 1; 
		}; 

		// Remove Mission EH
		removeMissionEventHandler ["Draw3D",_namePlateEH];
	};
}; 

[_initplatersfnc] remoteExec ["call",0,true];
/*
---------------------------------------------
Adds Event Handlers To Draw Name Plates
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

ISNILS(GVAR(DRAWVEHICLENAMEPLATES),[]);
ISNILS(GVAR(ALLVEHICLENAMEPLATES),[]);

[] spawn {
	while {true} do {
		GVAR(DRAWVEHICLENAMEPLATES) = player nearEntities["Man", 20] select {
				_x in GVAR(ALLVEHICLENAMEPLATES)
			};
		sleep 1;
	};
};

addMissionEventHandler ["Draw3D", {
    {
        drawIcon3D ["", [1, 1, 1, 1], visiblePosition _x vectorAdd [0, 0, 2], 0.6, 0.6, 45, format ["%1 (Free Vehicle)", name _x], 2, 0.04, "PuristaSemiBold"];
    } forEach GVAR(DRAWVEHICLENAMEPLATES);
}];
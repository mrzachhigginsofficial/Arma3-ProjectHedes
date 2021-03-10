/*
---------------------------------------------
Track Mission Givers In Range To Add Name Plate
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

ISNILS(GVAR(ALLMISSIONGIVERS),[]);

[] spawn {
	while {true} do {
		GVAR(DRAWMISSIONGIVERS) = player nearEntities["Man", 20] select {
				_x in GVAR(ALLMISSIONGIVERS)
			};
		sleep 1;
	};
};
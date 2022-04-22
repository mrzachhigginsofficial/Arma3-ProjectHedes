/*
---------------------------------------------
Checks If Players Near
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_grp"];

(count(allPlayers select {
	private _playeri = _x;
	count((units _grp) select {(_x distance2D _playeri) < (dynamicSimulationDistance "Group")}) > 0;
})) > 0
/*
---------------------------------------------
Checks If Players Near
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_grp"];

allPlayers findIf ({
	private _playeri = _x;
	(units _grp) findIf {(_x distance2D _playeri) < (dynamicSimulationDistance "Group")} > -1
}) > -1
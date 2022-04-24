/*
---------------------------------------------
Checks If Players Near
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_obj"];

(allPlayers findIf {(_x distance2D _obj) < (dynamicSimulationDistance "Group")}) > -1
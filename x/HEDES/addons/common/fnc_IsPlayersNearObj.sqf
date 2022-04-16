/*
---------------------------------------------
Checks If Players Near
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_obj"];

count(allPlayers select {(_x distance _obj) < (dynamicSimulationDistance "Group")}) > 0;
/*
---------------------------------------------
Checks If Enemies Near
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_pvtpos", "_pvtlocalside"];
count((allPlayers select {!(side _x == _pvtlocalside)}) select {(_x distance2D _pvtpos) < (dynamicSimulationDistance "Group")}) > 0;
/*
---------------------------------------------
Create Dynamic Simulation Thread (And Return ID)
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params[["_prefix","COMATZONEDYNSIMTHREAD"],["_simdelay",15]];

private _maintenanceid = [_prefix] call FUNCMAIN(GenerateUID);
[_maintenanceid, FUNCMAIN(IsPlayersNearGroup), true, _simdelay] spawn FUNCMAIN(DynamicSimulation);

_maintenanceid
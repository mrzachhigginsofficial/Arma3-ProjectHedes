/*
---------------------------------------------
Create Dynamic Simulation Thread (And Return ID)
Author: ZanchoElGrande
---------------------------------------------
*/

params[["_simdelay",15]];

private _maintenanceid = ["COMATZONEDYNSIMTHREAD"] call FUNCMAIN(GenerateUID);
[_maintenanceid, FUNCMAIN(IsPlayersNearGroup), true, _simdelay] spawn FUNCMAIN(DynamicSimulation);

_maintenanceid
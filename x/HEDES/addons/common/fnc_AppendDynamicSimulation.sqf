/*
---------------------------------------------
Append Units To Dynamic Simulation Thread
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_maintenanceid","_grp"];
if(isNil _maintenanceid) then {missionNameSpace setVariable [_maintenanceid,[]]};
missionNameSpace setVariable [_maintenanceid,(missionNameSpace getVariable _maintenanceid) + [_grp]];
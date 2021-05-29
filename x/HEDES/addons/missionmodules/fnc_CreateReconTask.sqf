/*
---------------------------------------------
Create Recon Task
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _result = (_this + ["scout"]) call FUNCMAIN(CreateMissionTask);
_result
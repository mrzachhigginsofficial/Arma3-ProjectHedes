/*
---------------------------------------------
Create Destroy Task
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _result = (_this + ["destory"]) call FUNCMAIN(CreateMissionTask);
_result
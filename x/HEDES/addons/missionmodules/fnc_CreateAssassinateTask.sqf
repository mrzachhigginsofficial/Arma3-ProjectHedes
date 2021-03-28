/*
---------------------------------------------
Create Assassinate Task
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _result = (_this + ["kill"]) call FUNCMAIN(CreateMissionTask);
_result
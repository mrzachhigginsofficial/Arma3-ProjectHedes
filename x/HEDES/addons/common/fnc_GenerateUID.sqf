/*
---------------------------------------------
Generate Unique ID
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params[["_suffix","generic"]];

if (isNil QGVAR(RANDOMIDS)) then { missionNameSpace setVariable [QGVAR(RANDOMIDS),[]]; };

private _id = "";
while {_id in QGVAR(RANDOMIDS) or _id isEqualTo ""} do {_id = format["HEDES_%1_%2", _suffix, floor random 1048576]};

_listids = missionNameSpace getVariable QGVAR(RANDOMIDS);
_listids pushback _id;

_id
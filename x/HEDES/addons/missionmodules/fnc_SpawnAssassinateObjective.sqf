/*
---------------------------------------------
Spawns the AO For a Assassinate Task
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _missionobject      = param[0,"Land_CratesWooden_F"];
private _taskposition       = param[1,[]];
private _taskspawnargs      = param[2,[]];

private _enemysquad         = (_taskspawnargs + [_taskposition]) call FUNCMAIN(SpawnEnemySquad);
private _enemyvip           = (["['CUP_o_sla_Officer']",1] + [_taskposition]) call FUNCMAIN(SpawnEnemySquad);

[netId _enemysquad, netId _enemyvip]
/*
---------------------------------------------
Spawns the AO For a Assassinate Task
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _taskposition       = param[1,[]];
private _taskspawnargs      = param[2,[]];

private _enemysquad         = (_taskspawnargs + [_taskposition]) call FUNCMAIN(SpawnEnemySquad);
private _enemyvip           = (["['I_G_officer_F']",1] + [_taskposition]) call FUNCMAIN(SpawnEnemySquad);

[netId _enemysquad, netId _enemyvip]
/* 
--------------------------------------------------------------------
Spawns Objective Area

Description:
    Spawns a generic objective area with an object and an enemy
	squad.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

private _missiontype        = param[0,"default"];
private _missionobject      = param[1,"Land_CratesWooden_F"];
private _unitpool           = param[2,[]];
private _taskposition       = param[3,[]];
private _taskname           = param[4,""];
private _taskspawnargs      = param[5,[]];

private _enemysquad         = (_taskspawnargs + [_taskposition] + [_unitpool]) call FUNC(SpawnEnemySquad);
private _object             = createVehicle [_missionobject, _taskposition, [], 0,""];

[netId _enemysquad, netId _object];
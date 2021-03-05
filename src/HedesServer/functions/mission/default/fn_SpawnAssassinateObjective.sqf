/* 
--------------------------------------------------------------------
Spawns Objective Assassinate Objective

Description:
    Spawns a VIP target for the players group to assasinate.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _missiontype        = param[0,"default"];
private _missionobject      = param[1,"Land_CratesWooden_F"];
private _taskposition       = param[2,[]];
private _taskname           = param[3,""];
private _taskspawnargs      = param[4,[]];

private _enemysquad         = (_taskspawnargs + [_taskposition]) call FUNC(SpawnEnemySquad);
private _enemyvip           = ([["CUP_o_sla_Officer"],1] + [_taskposition]) call FUNC(SpawnEnemySquad);

[_enemyvip] call CBA_fnc_taskDefend;

[netId _enemysquad, netId _enemyvip]
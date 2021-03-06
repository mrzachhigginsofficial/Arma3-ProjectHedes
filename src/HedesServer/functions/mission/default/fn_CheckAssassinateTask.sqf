/*
--------------------------------------------------------------------
append Objects to group Mission Tracker.

Description:
default task checker. Checks to see if mission tasks are still
active.

notes:
None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitwith {};

private _playergroups = groupFromnetId param[0, netId group player];
private _enemygroup = groupFromnetId param[1, grpNull];
private _vipgroup = groupFromnetId param[2, grpNull];

while {
    count((units _vipgroup) select {
        alive _x
    }) > 0
    &&
    count((units _playergroups) select {
        _x in allPlayers
    }) > 0
} do {
    sleep 1
};

true
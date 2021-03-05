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
private _vipgroups = groupFromnetId param[2, grpNull];

while {
    (count(_vipgroups select {
        count((units _x) select {
            alive _x
        }) > 0
    }) > 0) &&
    (count(_playergroups select {
        count(units _x) > 0
    }) > 0)
} do {
    sleep 1
};

true
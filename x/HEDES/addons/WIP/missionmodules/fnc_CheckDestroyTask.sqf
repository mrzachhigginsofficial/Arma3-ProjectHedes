/*
---------------------------------------------
Check Status Of Destroy Task
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _missiongroups = _this select {
    !isNull (groupFromnetId _x)
} apply {
    groupFromnetId _x
};

private _playergroups = _this select {
    !isNull (groupFromnetId _x)
} apply {
    groupFromnetId _x
} select {
    count((units _x) select {
        _x in allplayers
    }) > 0
};

private _missionobjects = _this select {
    !isNull (objectFromNetId _x)
} apply {
    objectFromNetId _x
};

while {
    (count(_missionobjects select {
        alive _x
    }) > 0) &&
    (count(_playergroups select {
        count(units _x select {_x in allPlayers}) > 0
    }) > 0)
} do {
    sleep 1
};

true
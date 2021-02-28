/*
in the default scenario, we use a single squad, and an item.
Objective items will be [_enemysquad, _enemyobject].
It is encouraged to expand on this in additional mission types.
*/

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
        count(units _x) > 0
    }) > 0)
} do {
    sleep 1
};

true
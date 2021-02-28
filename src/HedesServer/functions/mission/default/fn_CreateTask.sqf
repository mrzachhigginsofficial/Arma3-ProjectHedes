private _id = param[0, netId (group player)];
private _missiontype = param[1, "_default"];
private _tasktitl = param[2, "New task title"];
private _taskdesc = param[3, "New task description"];

private _group = groupFromnetId _id;
private _missionTask = format["%1_killtask", _id];
private _randomPos = [[[position (leader _group), 300]], [[position (leader _group), 200], "water"], {
    count(allplayers select {
        _x distance _this < 100
    }) == 0
}] call BIS_fnc_randomPos;

private _randomPosEmpty = _randomPos findEmptyposition [15, 100];
if (count _randomPosEmpty > 0) then {
    _randomPos = _randomPosEmpty
};

[_group, [_missionTask], [_tasktitl, _taskdesc], _randomPos, 1, 3, true, "kill"] call BIS_fnc_taskCreate;
[_missionTask, "ASSIGNED"] call BIS_fnc_tasksetState;

[_randomPos, _missionTask]
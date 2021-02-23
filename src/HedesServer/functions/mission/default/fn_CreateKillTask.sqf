private _id = param[0, netId (group player)];

private _group = groupFromNetId _id;
private _missionTask = format["%1_killtask", _id];
private _randomPos = [[[position (leader _group), 300]], [[position (leader _group), 150], "water"], {count(allPlayers select {_x distance _this < 100}) == 0}] call BIS_fnc_randomPos;

[_group, [_missionTask], ["Nuetralize All Enemies", "Eliminate Enemy Patrol"], _randomPos, 1, 3, true, "kill"] call BIS_fnc_taskCreate;
[_missionTask, "ASSIGNED"] call BIS_fnc_tasksetState;

[_randomPos, _missionTask]
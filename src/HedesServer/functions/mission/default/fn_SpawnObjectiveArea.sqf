private _missiontype = param[0,"default"];
private _missionobject = param[1,"Land_CratesWooden_F"];
private _taskposition = param[2,[]];
private _taskname = param[3,""];
private _taskspawnargs = param[4,[]];

private _enemysquad = (_taskspawnargs + [_taskposition]) call HEDESServer_fnc_SpawnEnemySquad;
private _object = createVehicle [_missionobject, _taskposition, [], 0,""];

[netId _enemysquad, netId _object];
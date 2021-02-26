private _missiontype = param[0,"_default"];
private _taskposition = param[1,[]];
private _taskname = param[2,""];

private _taskspawnargs = [configFile >> "CfgHedesMissions" >> _missiontype, "taskspawnargs"] call HEDESServer_fnc_GetMissionArgProperties;

private _enemysquad = (_taskspawnargs + [_taskposition]) call HEDESServer_fnc_SpawnEnemySquad;
private _object = createVehicle ["Item_Laptop_Unfolded", _taskposition, [], 0,"CAN_COLLIDE"];

[netId _enemysquad, netId _object];
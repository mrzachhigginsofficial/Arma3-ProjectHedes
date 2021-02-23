/*
Manage group Mission Statuses
States:
0 - not in mission
1 - Mission assigned, not started
2 - Mission started
*/

private _uid = param[0, getPlayerUID player];
private _state = param[1, 0];
private _mission = param[2, nil];
private _profilevar = param[3, "HEDESServer_Global_playerMissionTracker"];

with missionNamespace do {
    if (isnil _profilevar) then {
        currentnamespace setVariable [_profilevar, []];
    };
    
    private _var = currentnamespace getVariable _profilevar;
    
    if(!(_uid in (_var apply {
        _x select 0
    }))) then {
        _var pushBack [_uid, _state, _mission,[],[]];
        currentnamespace setVariable [_profilevar, _var];
    } else {
        private _i = _var apply {
            _x select 0
        } find _uid;
        _var set [_i, [_uid, _state, _mission, [], []]];
        currentnamespace setVariable [_profilevar, _var];
    };
};

missionNamespace getVariable _profilevar
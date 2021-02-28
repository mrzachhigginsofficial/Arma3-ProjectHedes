/*
Determines if player group is in mission or not
*/

private _id = param[0, getPlayerUID player];
private _profilevar = param[1, "HEDESServer_Profile_playerMissionTracker"];

private _result = false;

with missionNamespace do {
    if (isnil _profilevar) then {
        currentnamespace setVariable [_profilevar, []];
    };
    
    private _var = currentnamespace getVariable _profilevar;
    
    if (_id in (_var apply {
        _x select 0
    })) then {
        private _i = _var apply {
            _x select 0
        } find _id;
        
		_result = _var select _i select 2;
    };
};

_result
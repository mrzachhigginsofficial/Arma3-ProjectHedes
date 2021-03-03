private _unit = param[0, ""];
private _corpse = param[1, ""];

private _state = [netId (group _this), GLOBALMISSIONTRACKERNAME] call HEDESServer_fnc_GetplayerMissionState;
private _poc = [];

if (_state > 0) then {
    switch(true)do{
        case (_state == 1): {
            _pos = _corpse getVariable "deploy"
        };
        case (_state == 2): {
            _pos = _corpse getVariable "ingress"
        };
    };
    hint "Mission in progress... transporting you back to AO.";
    [_this, _pos] call HEDESServer_fnc_moveplayerinMission;
};
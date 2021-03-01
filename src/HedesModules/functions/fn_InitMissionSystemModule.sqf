private _logic = param [0, objNull, [objNull]];
private _missionlist = [];
private _missiongivers = synchronizedObjects _logic select {
    _x isKindOf "Man"
};

// -- Detect Mission Giver modules
{
    private _hqmodule = objNull;
    private _deploymodule = objNull;
    private _ingressmodule = objNull;
    private _missionmodule = _x;    

    private _missiontaskmodules = [];
    
    {
        private _object = _x;
        private _type = typeOf _x;
        
        switch (true) do
        {
            case (typeOf _x == "HEDES_Missionmodule_HQ"): {
                _hqmodule = _x;
            };
            case (typeOf _x == "HEDES_Missionmodule_DEPLOY"): {
                _deploymodule = _x;
            };
            case (typeOf _x == "HEDES_Missionmodule_inGRESS"): {
                _ingressmodule = _x;
            };
            case (typeOf _x == "HEDES_Missionmodule_TASK"): {
                _missiontaskmodules pushBack _x;
            };
        };
    } forEach (synchronizedObjects _x);
    
    _missionlist pushBack [_hqmodule, _deploymodule, _ingressmodule, _missionmodule, _missiontaskmodules];

} forEach (synchronizedObjects _logic select {
    typeOf _x == "HEDES_Missionmodule_MANAGER"
});

// -- Add Mission System dialog to NPC
{
    [
        _x,
        [
            "Open Mission dialog",
            {
                _logic = _this select 3 select 0;
                _missionlist = _this select 3 select 1;
                
                [_logic, _missionlist] spawn HEDESmodules_fnc_ShowAvailableMissions;
            },
            [_logic,_missionlist],
            1.5,
            true,
            false,
            "",
            "player == leader(group player)", 5
        ]
    ] remoteExec ["addAction"];
} forEach _missiongivers;
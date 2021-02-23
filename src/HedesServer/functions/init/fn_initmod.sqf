HEDESServer_fnc_appendplayerMissionObject = {
    private _uid = param[0, getplayerUID player];
    private _missionvarstr = param[1, "HEDESServer_Profile_playerMissionTracker"];
    private _objarray = param[2, [netId group player]];
    
    private _missionvar = missionnamespace getVariable _missionvarstr;
    private _missionvarelement = "";
    
    if(!(_uid in (_missionvar apply {
        _x select 0
    }))) then {
        exit
    };
    
    private _i = _missionvar apply {
        _x select 0
    } find _uid;
    
    {
        switch (typeName _x) do
        {
            case "GROUP" : {
                _missionvarelement = _missionvar select _i select 3;
                _missionvarelement append (units _x);
                _missionvar select _i set [3, _missionvarelement];
            };
            case "OBJECT" : {
                _missionvarelement = _missionvar select _i select 3;
                _missionvarelement pushBack _x;
                _missionvar select _i set [3, _missionvarelement];
            };
            case "STRING" : {
                switch (true) do {
                    case (!isNull groupFromnetId _x):{
                        (units(groupFromnetId _x) apply {
                            _missionvarelement = _missionvar select _i select 3;
                            _missionvarelement pushBack _x;
                            _missionvar select _i set [3, _missionvarelement];
                        })
                    };
                };
            };
        };
    } forEach _objarray;
};

HEDESServer_fnc_setplayerTasklist = {
    private _player = param[0, player];
    private _missionvarstr = param[1, "HEDESServer_Global_playerMissionTracker"];
    private _taskname = param[1, ""];
    
    private _uid = getplayerUID _player;
    private _missionvar = call compile _missionvarstr;
    
    if(!(_uid in (_missionvar apply {
        _x select 0
    }))) then {
        exit
    };
    
    private _i = _missionvar apply {
        _x select 0
    } find _uid;
    
    _missionvar select _i select 4 pushBack _taskname;
};
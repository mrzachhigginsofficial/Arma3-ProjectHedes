private _logic = param [0, objNull, [objNull]];
private _missiongivers = synchronizedObjects _logic select {
    _x isKindOf "Man"
};

{
    private _hqmodule = objNull;
    private _deploymodule = objNull;
    private _ingressmodule = objNull;
    
    private _missiontype = _x getVariable ["Missiontype", "default"];
    private _missiondesc = _x getVariable ["MissionManagername", "default"];
    private _missionobject = _x getVariable ["MissionManagerObjecttype", "land_CratesWooden_F"];
    
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
        };
    } forEach (synchronizedObjects _x);
    
    {
        [
            _x,
            [
                format["Start Mission: %1", _missiondesc],
                {
                    _player = _this select 1;
                    _hqmodule = _this select 3 select 0;
                    _deploymodule = _this select 3 select 1;
                    _ingressmodule = _this select 3 select 2;
                    _missiontype = _this select 3 select 3;
                    _missionobject = _this select 3 select 4;
                    
                    [_player, _hqmodule, _deploymodule, _ingressmodule, _missiontype, _missionobject] remoteExec ["HEDESServer_fnc_defaultgroupMissionManager", 2];
                },
                [_hqmodule, _deploymodule, _ingressmodule, _missiontype, _missionobject],
                1.5,
                false,
                false,
                "",
                "player == leader(group player)", 5
            ]
        ] remoteExec ["addAction"];
    } forEach _missiongivers;
} forEach (synchronizedObjects _logic select {
    typeOf _x == "HEDES_Missionmodule_MANAGER"
})
addMissionEventHandler ["playerConnected",
    {
        params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
        
        _uid spawn {
            waitUntil {
                (alive (_this call BIS_fnc_getUnitByUid));
            };
            
            call compile format["%1isFirstspawn = true", _this];
            
            (_this call BIS_fnc_getUnitByUid) addEventHandler ["Respawn", {
                
                params ["_unit", "_corpse"];
                
                if (missionnamespace getVariable format["%1isFirstspawn", _uid]) then {
                    _unit call HEDESServer_fnc_SetupNewplayer;
                } else {
                    [_unit, _corpse] call HEDESServer_fnc_RespawnPlayer;
                };

            }];
        };
    }];
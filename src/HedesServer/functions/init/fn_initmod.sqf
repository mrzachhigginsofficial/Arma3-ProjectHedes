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

                private _uid = getPlayerUID _unit;
                private _spawnnewfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "spawnnewplayerfnc");
                private _respawnfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "respawnplayerfnc");
                private _spawnnewcmd = format["'%1' call %2", _uid, _spawnnewfnc];
                private _respawncmd = format["'%1' call %2", _uid, _respawnfnc];
                
                if (missionnamespace getVariable format["%1isFirstspawn", _uid]) then {
                    call compile _spawnnewcmd;
                } else {
                    call compile _respawncmd;
                };
            }];
        };
    }];
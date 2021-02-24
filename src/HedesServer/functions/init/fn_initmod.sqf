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
                
                if (missionnamespace getVariable format["%1isFirstspawn", getplayerUID _unit]) then {
                    _unit call HEDESServer_fnc_setupNewplayer;
                } else {
                    private _groupid = netId (group _unit);
                    private _trackervarname = gettext(configFile >> "CfgHedesMissions" >> "playermissiontrackerglobal");
                    private _getmissionstatefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionstategetterfnc");
                    private _getmissionnamefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionnamegetterfnc");
                    if (call compile format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionstatefnc]) then {
                        private _missiontype = call compile format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionnamefnc];
                        private _missionaoargs = [configFile >> "CfgHedesMissions" >> _missiontype, "missiontargetareaargs"] call HEDESServer_fnc_GetMissionArgProperties;
                        private _ingresspos = call compile format["%2 call %1", "HEDESServer_fnc_GetLocationPosByname", _missionaoargs];
                        private _ingresexpression = gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "missiondingressambientexpre");
                        hint "Mission in progress... transporting you back to AO in 5 seconds.";
                        [_unit, _ingresspos, _ingresexpression]  spawn {
                            sleep 5;
                            (_this select 0) setPos (selectRandom(selectBestPlaces [(_this select 1), 50, (_this select 2), 1, 5]) select 0);
                        };                        
                    };
                };
            }];
        };
    }];
    
    HEDESServer_fnc_setupNewplayer = {
        [_this] joinSilent (creategroup [west, true]);
        call compile format["%1isFirstspawn = false", getplayerUID _this];
        {
            [_x, group _this] call BIS_fnc_deleteTask;
        } forEach (_this call BIS_fnc_tasksUnit);
    }
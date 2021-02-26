private _unit = _this call BIS_fnc_getUnitByUid;

private _groupid = netId (group _unit);

// Config Lookup
private _compilecamfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "compileplayertransitioncamfnc");
private _trackervarname = gettext(configFile >> "CfgHedesMissions" >> "playermissiontrackerglobal");
private _getmissionnamefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionnamegetterfnc");
private _missiontype = call compile format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionnamefnc];
private _missionaoargs = [configFile >> "CfgHedesMissions" >> _missiontype, "missiontargetareaargs"] call HEDESServer_fnc_GetMissionArgProperties;
private _ingresspos = call compile format["%2 call %1", "HEDESServer_fnc_GetLocationPosByname", _missionaoargs];
private _ingresexpression = gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "missiondingressambientexpre");
private _getrelposfnc = getArray(configFile >> "CfgHedesMissions" >> "missiontargetarearelpos");

// Commands
private _deploycamcmd = format["['%1','deploycam',%2] call %3", _missiontype, owner _unit, _compilecamfnc];
private _missioncamcmd = format["['%1','missionStartcam',%2] call %3", _missiontype, owner _unit, _compilecamfnc];

call compile _deploycamcmd;
sleep 2;
_unit setPos (selectRandom(selectBestPlaces [_ingresspos, 50, _ingresexpression, 1, 5]) select 0);
call compile _missioncamcmd;
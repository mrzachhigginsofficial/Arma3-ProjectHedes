private _unit = _this call BIS_fnc_getUnitByUid;

private _groupid = netId (group _unit);
private _trackervarname = gettext(configFile >> "CfgHedesMissions" >> "playermissiontrackerglobal");
private _getmissionstatefnc  = gettext(configFile >> "CfgHedesMissions" >> "playermissionstategetterfnc");
private _getmissionnamefnc   = gettext(configFile >> "CfgHedesMissions" >> "playermissionnamegetterfnc");

if (call compile format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionstatefnc]) then {
	private _missiontype = call compile format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionnamefnc];
	private _missionaoargs = [configFile >> "CfgHedesMissions" >> _missiontype, "missiontargetareaargs"] call HEDESServer_fnc_GetMissionArgProperties;
	private _ingresspos = call compile format["%2 call %1", "HEDESServer_fnc_GetLocationPosByname", _missionaoargs];
	private _ingresexpression = gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "missiondingressambientexpre");
	private _moveplayerfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "moveplayerfnc");
	private _moveplayercmd = format["['%1',%2,%3,'%4'] spawn %5",getPlayerUID _unit, _ingresspos, _ingresexpression, _missiontype, _moveplayerfnc];
	hint "Mission in progress... transporting you back to AO in 5 seconds.";
	call compile _moveplayercmd;
};
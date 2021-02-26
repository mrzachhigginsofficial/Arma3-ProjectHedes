private _unit = _this call BIS_fnc_getUnitByUid;

private _groupid = netId (group _unit);
private _trackervarname = gettext(configFile >> "CfgHedesMissions" >> "playermissiontrackerglobal");
private _getmissionstatefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionstategetterfnc");
private _getmissionnamefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionnamegetterfnc");

if (call compile format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionstatefnc]) then {
	private _moveplayerfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "moveplayerfnc");
	private _moveplayercmd = format["'%1' spawn %2",getPlayerUID _unit, _moveplayerfnc];
	hint "Mission in progress... transporting you back to AO.";
	call compile _moveplayercmd;
};
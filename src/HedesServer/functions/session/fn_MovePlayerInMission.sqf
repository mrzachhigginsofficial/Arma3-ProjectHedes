private _unit = param[0,""];
private _pos = param[1,[]];

private _groupid = netId group _unit;

// Config Lookup
private _compilecamfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "compileplayertransitioncamfnc");
private _trackervarname = gettext(configFile >> "CfgHedesMissions" >> "playermissiontrackerglobal");
private _getmissionnamefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionnamegetterfnc");
private _missiontype = call compile format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionnamefnc];

// Commands
private _deploycamcmd = format["['%1','deploycam',%2] call %3", _missiontype, owner _unit, _compilecamfnc];
private _missioncamcmd = format["['%1','missionStartcam',%2] call %3", _missiontype, owner _unit, _compilecamfnc];

call compile _deploycamcmd;
sleep 2;
_unit setPos _pos;
call compile _missioncamcmd;
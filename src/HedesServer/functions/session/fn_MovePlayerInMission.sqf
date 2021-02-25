private _unit = _this call BIS_fnc_getUnitByUid;

private _compilecamfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "compileplayertransitioncamfnc");
private _deploycamcmd = format["[%1,'deploycam',%2] call %3",_this select 3, owner _unit, _compilecamfnc];
private _missioncamcmd = format["[%1,'missionStartcam',%2] call %3",_this select 3, owner _unit, _compilecamfnc];

call compile _deploycamcmd;
sleep 2;
_unit setPos (selectRandom(selectBestPlaces [(_this select 1), 50, (_this select 2), 1, 5]) select 0);
call compile _missioncamcmd;
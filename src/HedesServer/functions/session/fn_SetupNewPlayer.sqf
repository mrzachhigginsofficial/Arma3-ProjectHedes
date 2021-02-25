private _unit = _this call BIS_fnc_getUnitByUid;

[_unit] joinSilent (creategroup [west, true]);
call compile format["%1isFirstspawn = false", getplayerUID _unit];
{
	[_x, group _unit] call BIS_fnc_deleteTask;
} forEach (_unit call BIS_fnc_tasksUnit);
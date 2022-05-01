/*
---------------------------------------------
Move Large Smoke Cloud Function
Author: ZanchoElGrande
---------------------------------------------
*/	
	
params["_id","_positions"];

private _objsid = format["%1_OBJS",_id];

if (isNil _objsid) then 
{
	missionNamespace setVariable [_objsid,[]];
};

{deleteVehicle _x;} foreach (missionNamespace getVariable _objsid);

private _objlist = (missionNamespace getVariable _objsid);
{
	if (player distance2D _x < viewDistance) then
	{
		_smoke = "#particlesource" createVehicleLocal _x;
		_smoke setParticleClass "HouseDestrSmokeLong";
		_objlist pushBack _smoke;
	};
} foreach _positions;
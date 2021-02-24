/*
Appends any element type to array. This shouldnt really need changed except for parm types expanded on.
The collection this is appended to is used to clean objects at garbage collection.
*/

private _uid = param[0, getplayerUID player];
private _missionvarstr = param[1, "HEDESServer_Profile_playerMissionTracker"];
private _objarray = param[2, [netId group player]];

private _missionvar = missionnamespace getVariable _missionvarstr;
private _missionvarelement = "";

if(!(_uid in (_missionvar apply {
	_x select 0
}))) then {
	exit
};

private _i = _missionvar apply {
	_x select 0
} find _uid;

{
	switch (typeName _x) do
	{
		case "GROUP" : {
			_missionvarelement = _missionvar select _i select 3;
			_missionvarelement append (units _x);
			_missionvar select _i set [3, _missionvarelement];
		};
		case "OBJECT" : {
			_missionvarelement = _missionvar select _i select 3;
			_missionvarelement pushBack _x;
			_missionvar select _i set [3, _missionvarelement];
		};
		case "STRING" : {
			switch (true) do {
				case (!isNull groupFromnetId _x):{
					(units(groupFromnetId _x) apply {
						_missionvarelement = _missionvar select _i select 3;
						_missionvarelement pushBack _x;
						_missionvar select _i set [3, _missionvarelement];
					})
				};
			};
		};
	};
} forEach _objarray;
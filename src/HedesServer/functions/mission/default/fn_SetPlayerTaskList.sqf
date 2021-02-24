/*
This adds a list of tasks to the player tracking variable. This shouldnt need changed.
*/

private _player = param[0, player];
private _missionvarstr = param[1, "HEDESServer_Global_playerMissionTracker"];
private _taskname = param[1, ""];

private _uid = getplayerUID _player;
private _missionvar = call compile _missionvarstr;

if(!(_uid in (_missionvar apply {
	_x select 0
}))) then {
	exit
};

private _i = _missionvar apply {
	_x select 0
} find _uid;

_missionvar select _i select 4 pushBack _taskname;
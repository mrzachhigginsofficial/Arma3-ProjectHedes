/*

*/

/* 
--------------------------------------------------------------------
Set Player Mission Current Task Name In Tracker

Description:
    Sets the current player task name in tracker.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _player 		= param[0, player];
private _taskname 		= param[1, ""];

private _uid 			= getplayerUID _player;
private _missionvar 	= call compile GLOBALMISSIONTRACKERNAME;

if(!(_uid in (_missionvar apply {
	_x select 0
}))) then {
	exit
};

private _i = _missionvar apply {
	_x select 0
} find _uid;

_missionvar select _i select 4 pushBack _taskname;
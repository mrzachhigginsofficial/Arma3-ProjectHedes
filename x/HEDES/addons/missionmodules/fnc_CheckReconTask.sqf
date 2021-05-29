/*
---------------------------------------------
Check Assassinate Task
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _playergroups = groupFromnetId param[0, netId group player];
private _enemygroup = groupFromnetId param[1, grpNull];
private _vipgroup = groupFromnetId param[2, grpNull];
private _reconscore = 0;
private _reconscoresuccess = 100;
private _reconstatusstring = "";
private _taskstatus = false;


while {
    count((units _vipgroup) select {
        alive _x
    }) > 0
    &&
    count((units _playergroups) select {
        _x in allPlayers
    }) > 0
	&&
	_reconscore < _reconscoresuccess
} do {
	{		
		if(([objNull, "VIEW"] checkVisibility [eyePos _x, eyePos (leader _vipgroup)] == 1) && _taskstatus == false) then {
			_reconscore = _reconscore + 10;
	
			(compile format["cutText [""<t color='#FFFFFF' size='3'>Recon Complete: %1 / 100</t>"",'PLAIN DOWN', 2, true, true]",str _reconscore]) 
				remoteExec ["BIS_fnc_call",groupFromNetId _groupid];

			if(_reconscore >= _reconscoresuccess) then {_taskstatus = true};
		};
		sleep 2;
	} foreach (units _playergroups);		

    sleep 1;
};

_taskstatus
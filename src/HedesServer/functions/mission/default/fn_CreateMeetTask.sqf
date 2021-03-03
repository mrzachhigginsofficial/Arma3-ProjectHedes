/* 
--------------------------------------------------------------------
Create Meet Task 

Description:
	Create move task and wait for all group members to be within 
	10 meters of task position.

Notes: 
    None

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

private _group 			= param[0,objNull];
private _pos 			= param[1,[]];
private _title 			= param[2,"Begin Mission"];
private _description	= param[3,"Move all players in squad to marker to begin mission."];

private _missionTask 	= format["%1_killtask", netid _group];

[_group, [format["%1_meetmissiontask", netid _group]], [_description, _title, "cookiemarker"], _pos, 1, 2, true, "meet"] call BIS_fnc_taskCreate;

while {
	count (units _group select {
		_x in allplayers
	} select {
		_x distance _pos > 10
	}) > 0
} do
{
	sleep 1;
};

[_missionTask] call BIS_fnc_deleteTask;
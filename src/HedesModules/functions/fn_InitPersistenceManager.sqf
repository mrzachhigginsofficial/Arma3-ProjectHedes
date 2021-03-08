/*
--------------------------------------------------------------------
Initialize Persistence Manager

Description:
	Saves units loadout on spawn (and loads on first spawn) to/from 
	profilenamespace.

Notes:
	None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};


addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];	
	[_uid, _unit] call FUNC(SaveLoudOut);
}];


addMissionEventHandler ["playerConnected", {
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
	waitUntil {alive (_uid call BIS_fnc_getUnitByUid)};
	(_uid call BIS_fnc_getUnitByUID) call FUNC(LoadLoadOut);
}];


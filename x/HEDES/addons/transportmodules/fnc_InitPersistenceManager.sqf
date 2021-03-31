/*
---------------------------------------------
Loads Unit Loadout
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};



addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];	
	[_uid, _unit] call FUNCMAIN(SaveLoudOut);
}];


addMissionEventHandler ["playerConnected", {
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
	waitUntil {alive (_uid call BIS_fnc_getUnitByUid)};
	(_uid call BIS_fnc_getUnitByUID) call FUNCMAIN(LoadLoadOut);
}];


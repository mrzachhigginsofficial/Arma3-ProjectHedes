/*
---------------------------------------------
Loads Unit Loadout
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _data = [profileNamespace, QGVARMAIN(PROFILESAVEDUNITLOADOUTS), getPlayerUID _this] call FUNCMAIN(GetData);

if (!isNil {_data}) then
{
	_this setUnitLoadout _data;
};

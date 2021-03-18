/*
---------------------------------------------
Loads Unit Loadout
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

if (isNil {profilenamespace getVariable QGVARMAIN(PROFILESAVEDUNITLOADOUTS) }) exitWith { echo "Nothing has been saved."};

private _player = _this;
private _data = [(profilenamespace getvariable QGVARMAIN(PROFILESAVEDUNITLOADOUTS) ), getplayeruid _this] call CBA_fnc_hashGet;

if (!isNil {_data}) then
{
	_player setUnitLoadout _data;
};


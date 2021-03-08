/*
--------------------------------------------------------------------
Save Unit Loadout To Profile Namespace

Description:
	Saves the units loadout and UID to player name space.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};
if (isNil {profilenamespace getVariable PROFILESAVEDUNITLOADOUTS }) exitWith { echo "Nothing has been saved."};

private _player = _this;
private _data = [(profilenamespace getvariable PROFILESAVEDUNITLOADOUTS ), getplayeruid _this] call CBA_fnc_hashGet;

if (!isNil {_data}) then
{
	_player setUnitLoadout _data;
};


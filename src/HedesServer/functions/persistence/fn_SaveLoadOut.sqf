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

private _unit = param[0,player];
private _uid = param[1,getPlayerUID _unit];
private _data = getUnitLoadout [_unit, false];

if (isNil {profilenamespace getVariable PROFILESAVEDUNITLOADOUTS }) then 
{
	private _default = [] call CBA_fnc_hashCreate; 
	profileNamespace setVariable [ PROFILESAVEDUNITLOADOUTS , _default ];
};

private _sethash = profileNameSpace getVariable PROFILESAVEDUNITLOADOUTS ;
[_sethash, _uid, _data] call CBA_fnc_hashSet;

saveProfileNamespace;
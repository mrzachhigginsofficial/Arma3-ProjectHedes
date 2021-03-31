/*
---------------------------------------------
Saves the Unit Loadout To Profile NameSpace
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _unit = param[0,player];
private _uid = param[1,getPlayerUID _unit];
private _data = getUnitLoadout [_unit, false];

if (isNil {profilenamespace getVariable QGVARMAIN(PROFILESAVEDUNITLOADOUTS) }) then 
{
	private _default = [] call CBA_fnc_hashCreate; 
	profileNamespace setVariable [ QGVARMAIN(PROFILESAVEDUNITLOADOUTS) , _default ];
};

private _sethash = profileNameSpace getVariable QGVARMAIN(PROFILESAVEDUNITLOADOUTS) ;
[_sethash, _uid, _data] call CBA_fnc_hashSet;

saveProfileNamespace;
/*
---------------------------------------------
Set Hash Data
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_namespace", "_hash", "_key", "_data"];

if (!isServer) exitWith {};

if (isNil {_namespace getVariable _hash}) then 
{
	private _default = [] call CBA_fnc_hashCreate; 
	_namespace setVariable [_hash, _default ];
};

private _sethash = _namespace getVariable _hash;
[_sethash, _key, _data] call CBA_fnc_hashSet;

saveProfileNamespace;

true;
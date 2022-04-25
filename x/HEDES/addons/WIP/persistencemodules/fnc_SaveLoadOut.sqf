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

[profileNamespace, QGVARMAIN(PROFILESAVEDUNITLOADOUTS), _uid, _data] call FUNCMAIN(SetData);
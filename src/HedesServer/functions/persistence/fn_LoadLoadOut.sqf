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

private _player = _this;

private _savedloadouts = profileNameSpace getVariable [ PROFILESAVEDUNITLOADOUTS , []];
private _loudout = _savedloadouts select {_x select 0 == getPlayerUID _player} select 1;
_player setUnitLoadout _loudout;
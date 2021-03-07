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
_savedloadouts pushBack [GetPlayerUID _player, getUnitLoadout [_player, true]];
profileNamespace setVariable [ PROFILESAVEDUNITLOADOUTS , _savedloadouts ];

saveProfileNamespace;
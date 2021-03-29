/*
---------------------------------------------
Init Default Loadout Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];
private _loadout = call compile(_logic getVariable "DefaultLoadout");
private _actionobject = synchronizedObjects _logic;

ISNILS(GVAR(ALLLOADOUTNAMEPLATES),[]);

{
	GVAR(ALLLOADOUTNAMEPLATES) pushback _x;
	[
		_x, ["Get default unit loadout...", {(_this select 1) setUnitLoadout (_this select 3)}, _loadout, 1.5, true, true, "", "true", 10]
	] remoteExec ["addAction",0,true];
} foreach _actionobject;
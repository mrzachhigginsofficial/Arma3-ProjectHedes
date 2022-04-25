/*
---------------------------------------------
Loads Unit Loadout
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

player addMPEventHandler ["MPRespawn", {
	params ["_unit", "_corpse"];

	// Cleanup
	removeAllActions _corpse;

	// Add Retrieve Inventory From Server
	[_unit,
		[
			"Load Inventory From Server",
			{
				private _unit = _this # 3;
				_unit remoteExec [QUOTE(FUNCMAIN(LoadLoadOut)),2,false];
			},
			_unit,
			1.5,
			true,
			true,
			"",
			"true"
		]
	] remoteExec ["addAction",owner _unit,false];

	// Add Save Inventory To Server
	[_unit,
		[
			"Save Inventory To Server",
			{
				private _unit = _this # 3;
				[_unit] remoteExec [QUOTE(FUNCMAIN(SaveLoadOut)),2,false];
			},
			_unit,
			1.5,
			true,
			true,
			"",
			"true"
		]
	] remoteExec ["addAction",owner _unit,false];
}];
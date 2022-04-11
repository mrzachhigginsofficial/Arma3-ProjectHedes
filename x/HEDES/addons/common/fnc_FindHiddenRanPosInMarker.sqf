/*
---------------------------------------------
Looks For Hidden Position
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params ["_marker",["_isOnRoad", true]];

private _rndpos = [0,0];
private _maxi = 30;
private _i = 0;

while {_rndpos isEqualTo [0,0] && (_i < _maxi)} do 
{
	private _eval = if (_isOnRoad) then {
		{
			(isOnRoad _this) && 
			!([_this] call FUNCMAIN(IsPlayersNearObj)) &&
			count(_this nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"],50]) == 0
		}
	} else {
		{
			!([_this] call FUNCMAIN(IsPlayersNearObj)) &&
			count(_this nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"],50]) == 0
		}
	};

	_rndpos = [[_marker], [], _eval] call BIS_fnc_randomPos;

	_i = _i+1;
};

_rndpos
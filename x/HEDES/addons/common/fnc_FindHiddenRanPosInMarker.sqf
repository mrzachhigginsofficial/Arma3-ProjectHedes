/*
---------------------------------------------
Looks For Hidden Position
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params ["_marker",["_isOnRoad", true],["_distance",25]];

private _rndpos = [0,0];
private _maxi = 30;
private _i = 0;

while {_rndpos isEqualTo [0,0] && (_i < _maxi)} do 
{
	private _eval = if (_isOnRoad) then {
		{
			(isOnRoad _this) && 
			!([_this] call FUNCMAIN(IsPlayersNearObj)) &&
			count(_this nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"],_distance]) == 0
		}
	} else {
		{
			!([_this] call FUNCMAIN(IsPlayersNearObj)) &&
			count(_this nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"],_distance]) == 0
		}
	};

	_rndpos = [[_marker], [], _eval] call BIS_fnc_randomPos;

	_i = _i+1;
};

if (_rndpos isNotEqualTo [0,0]) then 
{
	_rndpos = [_rndpos, 1, 25, 3, 0, 20, 0] call BIS_fnc_findSafePos;
}; 

_rndpos
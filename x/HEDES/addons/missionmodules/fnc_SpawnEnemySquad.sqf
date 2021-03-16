/*
---------------------------------------------
Spawns an Enemy Squad
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _enemytypes         = call compile param[0, []];
private _amount             = param[1, 5];
private _position           = param[2, []];

private _enemygroup         = creategroup [east, true];

while {count (units _enemygroup) < _amount} do {
    systemChat format["%1",selectRandom _enemytypes];
    (selectRandom _enemytypes) createUnit [_position, _enemygroup]
};

[_enemygroup, getPos (leader _enemygroup), 25, 3, false, 100] call CBA_fnc_taskDefend;
_enemygroup allowfleeing 0;

_enemygroup
/* 
--------------------------------------------------------------------
Spawn Enemy Squad

Description:
    Spawns an enemy squad.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

private _enemytypes         = param[0, []];
private _amount             = param[1, 5];
private _position           = param[2, []];
private _unitpool           = param[3, ["CUP_O_TK_INS_Soldier_Enfield"]];

private _enemygroup         = creategroup [east, true];

while {count (units _enemygroup) < _amount} do {
    (selectRandom _unitpool) createUnit [_position, _enemygroup]
};

[_enemygroup, getPos (leader _enemygroup), 25, 3, false, 100] call CBA_fnc_taskDefend;
_enemygroup allowfleeing 0;

_enemygroup
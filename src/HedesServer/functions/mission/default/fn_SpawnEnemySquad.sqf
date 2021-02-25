private _enemytypes = param[0, []];
private _amount = param[1,5];
private _position = param[2,[]];

private _enemygroup = creategroup [east, true];

while {count (units _enemygroup) < _amount} do {
    (selectRandom _enemytypes) createUnit [_position, _enemygroup]
};
[_enemygroup, getPos (leader _enemygroup), 20] call BIS_fnc_taskPatrol;
_enemygroup allowFleeing 0;

[netId _enemygroup]
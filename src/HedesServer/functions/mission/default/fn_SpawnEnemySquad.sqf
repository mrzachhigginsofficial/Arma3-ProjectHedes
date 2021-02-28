private _enemytypes = param[0, []];
private _amount = param[1, 5];
private _position = param[2, []];

private _enemygroup = creategroup [east, true];

{
    systemChat format["%1", _x];
}forEach[ _amount];

while {count (units _enemygroup) < _amount} do {
    (selectRandom _enemytypes) createUnit [_position, _enemygroup]
};

[_enemygroup, getPos (leader _enemygroup), 25, 3, false, 100] call CBA_fnc_taskDefend;
_enemygroup allowfleeing 0;

_enemygroup
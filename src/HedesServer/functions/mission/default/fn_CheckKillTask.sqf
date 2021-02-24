private _enemygrpnetId = param[0, ""];
private _taskgrpnetId = param[1, ""];
private _enemygrp = groupFromnetId _enemygrpnetId;
private _taskgrp = groupFromnetId _taskgrpnetId;

while {
    count((units _enemygrp) select {
        alive _x && primaryWeapon _x != ""
    }) > 0 &&
    !(fleeing leader _enemygrp) &&
    count((units _taskgrp) select {
        _x in allplayers
    }) > 0
} do {
    sleep 1
};

true
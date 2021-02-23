private _enemygrpnetId = param[0, ""];
private _enemygrp = groupFromnetId _enemygrpnetId;

while {
    count((units _enemygrp) select {
        alive _x && primaryWeapon _x != ""
    }) > 0 &&
    !(fleeing leader _enemygrp)
} do {
    sleep 1
};

true
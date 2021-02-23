private _id = param[0, netId(group player)];

(groupFromnetId _id) spawn {
    while {
        (count((units _this) select {
            alive _x
        })) > 0;
    } do {
        if (morale (leader _this) < -.7) then {
            {
                _x spawn {
                    private _weaponHolder = createvehicle ["Weapon_Empty", _this getRelPos [2, random 360], [], 0, "CAN_COLLIDE"];
                    _weaponHolder addweaponCargo [primaryWeapon _this, 1];
                    removeAllweapons _this;
                    
                    _this setCaptive true;
                    _this playMoveNow "ApanPknlMstpSnonWnonDnon_G03";
                    
                    waitUntil {
                        count(_this nearEntities ["Man", 50] select {
                            _x in allplayers
                        }) == 0;
                    };
                    
                    deletevehicle _weaponHolder;
                    deletevehicle _this;
                }
            } forEach (units _this select {
                alive _x
            })
        };
        
        sleep 2;
    }
};
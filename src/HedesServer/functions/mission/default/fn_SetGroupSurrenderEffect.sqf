/* 
--------------------------------------------------------------------
Group Surrender Effect

Description:
    Makes the group surrender when leader morale reduces.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

{
    (groupFromnetId _x) spawn {
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
                            count(_this nearEntities ["Man", 200] select {
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
} forEach ((_this select {
    typeName _x == "STRING"
}) select {
    (!isNull groupFromnetId _x)
})
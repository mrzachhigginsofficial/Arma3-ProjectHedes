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
if (!isServer) exitWith {};

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

                        _weaponHolder call FUNC(AddUnitToCleanupList);
                        _this call FUNC(AddUnitToCleanupList);
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
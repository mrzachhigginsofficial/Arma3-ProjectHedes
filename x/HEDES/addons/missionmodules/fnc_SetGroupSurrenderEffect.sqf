/*
---------------------------------------------
Sets Unit Surrender Effect
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

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

                        _weaponHolder call FUNCMAIN(AddUnitToCleanupList);
                        _this call FUNCMAIN(AddUnitToCleanupList);
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
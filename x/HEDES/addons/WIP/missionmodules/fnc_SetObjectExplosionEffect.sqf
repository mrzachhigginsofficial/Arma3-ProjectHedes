/*
---------------------------------------------
Adds Plant Explosiev Action To Object
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

if (!isServer) exitWith {};

{
    [
        objectFromNetId _x,
        [
            "Plant explosive Charge (Run!)",
            {
                private _object = _this select 0;
                private _scriptedCharge = "DemoCharge_Remote_ammo_Scripted" createvehicle (getPos _object);
                private _c = 20;
                while {_c > 0} do {
                    playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\timer.wss", _object];
                    sleep 1;
                    _c = _c - 1;
                };
                
                _scriptedCharge setDamage 1;
            },
            [],
            1.5,
            true,
            false,
            "",
            "true", 5
        ]
    ] remoteExec ["addAction"];
} forEach ((_this select {
    typeName _x == "STRING"
}) select {
    (!isNull objectFromNetId _x)
})
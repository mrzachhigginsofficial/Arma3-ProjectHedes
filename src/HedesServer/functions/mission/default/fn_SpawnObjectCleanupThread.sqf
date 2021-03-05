/* 
--------------------------------------------------------------------
Object Cleanup Thread

Description:
    Spawns an object cleanup thread. Waits until players are away 
    from object.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

{
    _x spawn {
        while{
            count(_x nearEntities ["Man", 1000] select {
                _x in allplayers
            })>0;
        } do {
            sleep 10
        };
        try{
            deletevehicle _x;
        }
        catch{
            echo format["Cleanup object failed: %1... %2", netId _x, _exception]
        }
    }
} forEach _this
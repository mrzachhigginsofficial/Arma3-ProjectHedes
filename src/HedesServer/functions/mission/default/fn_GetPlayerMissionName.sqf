/* 
--------------------------------------------------------------------
Get Player Mission Name.

Description:
    Gets player mission name from global mission tracker.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

private _id         = param[0, getPlayerUID player];
private _result     = false;

with missionNamespace do {
    if (isnil GLOBALMISSIONTRACKERNAME) then {
        currentnamespace setVariable [GLOBALMISSIONTRACKERNAME, []];
    };
    
    private _var = currentnamespace getVariable GLOBALMISSIONTRACKERNAME;
    
    if (_id in (_var apply {
        _x select 0
    })) then {
        private _i = _var apply {
            _x select 0
        } find _id;
        
		_result = _var select _i select 2;
    };
};

_result
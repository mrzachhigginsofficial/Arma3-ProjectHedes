/* 
--------------------------------------------------------------------
Get Player Mission Objects.

Description:
    Gets player mission objects from global mission tracker.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _id         = param[0, netId group player];
private _result     = [];

if (isnil GLOBALMISSIONTRACKERNAME) then {
    missionNamespace setVariable [GLOBALMISSIONTRACKERNAME, []];
};

private _var = missionNamespace getVariable GLOBALMISSIONTRACKERNAME;

if (_id in (_var apply {
    _x select 0
})) then {
    private _i = _var apply {
        _x select 0
    } find _id;
    
    _result = _var select _i select 3;
};

_result
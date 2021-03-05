/* 
--------------------------------------------------------------------
Get Player Mission State.

Description:
    Gets player mission status. Returns true if in mission.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _uid        = param[0, getPlayerUID player];
private _result     = 0;

if (isnil GLOBALMISSIONTRACKERNAME) then {
    missionNamespace setVariable [GLOBALMISSIONTRACKERNAME, []];
};

private _var = missionNamespace getVariable GLOBALMISSIONTRACKERNAME;

if (_uid in (_var apply {
    _x select 0
})) then {
    private _i = _var apply {
        _x select 0
    } find _uid;
    _result = _var select _i select 1
};

_result
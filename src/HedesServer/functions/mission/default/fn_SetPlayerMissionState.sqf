/* 
--------------------------------------------------------------------
Set Player Mission State

Description:
    Manage Group Mission Statuses
    States:
    0 - not in mission
    1 - Mission assigned, not started
    2 - Mission started

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

private _uid        = param[0, getPlayerUID player];
private _state      = param[1, 0];
private _mission    = param[2, nil];

if (isnil GLOBALMISSIONTRACKERNAME) then {
    currentnamespace setVariable [GLOBALMISSIONTRACKERNAME, []];
};

private _var = currentnamespace getVariable GLOBALMISSIONTRACKERNAME;

if(!(_uid in (_var apply {
    _x select 0
}))) then {
    _var pushBack [_uid, _state, _mission,[],[]];
    currentnamespace setVariable [GLOBALMISSIONTRACKERNAME, _var];
} else {
    private _i = _var apply {
        _x select 0
    } find _uid;
    _var set [_i, [_uid, _state, _mission, [], []]];
    currentnamespace setVariable [GLOBALMISSIONTRACKERNAME, _var];
};

missionNamespace getVariable GLOBALMISSIONTRACKERNAME
/* 
--------------------------------------------------------------------
Initialize Mission System Module. 

Description:
    Initializes the mission system module.

Notes: 
    This script needs parameterized as much as possible...

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "..\macros.h"
#include "..\defines.h"

private _logic = param [0, objNull, [objNull]];
private _missiongivers = synchronizedObjects _logic select {
    _x isKindOf "Man"
};
private _randomize = _logic getVariable "MissionGiverRandomize";
private _refreshtime = _logic getVariable ["MissionGiverRefresh","360"];

while {
    true
} do
{
    private _missionmanagers = synchronizedObjects _logic select { typeOf _x == "HEDES_Missionmodule_MANAGER" };
    private _missionlist = [];

    // -- If Randomize Missions Enabled
    if(_randomize) then
    {
        private _rndmax = count(_missionmanagers);
        private _rndmid = _rndmax/2;
        private _rnd = floor random[0,_rndmid, _rndmax];
        
        if (count(_missionmanagers) > _rndmax) then {
            echo "Not enough mission managers attached to randomize.";
            continue;
        };
        
        private _rndmissionmanagers = [];
        while { count(_rndmissionmanagers) < _rnd } do 
        {
            _rndmissionmanagers pushback (selectRandom (_missionmanagers select {!(_x in _rndmissionmanagers)}));
        };
        _missionmanagers = _rndmissionmanagers;
    };

    // -- Detect Mission Giver modules
    {
        private _hqmodule = objNull;
        private _deploymodule = objNull;
        private _ingressmodule = objNull;
        private _missionmodule = _x;    
        private _maxtasks = 5;

        private _missiontaskmodules = [];
        
        {        
            switch (true) do
            {
                case (typeOf _x == "HEDES_MissionModule_HQ"): {
                    _hqmodule = _x;
                };
                case (typeOf _x == "HEDES_MissionModule_DEPLOY"): {
                    _deploymodule = _x;
                };
                case (typeOf _x == "HEDES_MissionModule_INGRESS"): {
                    _ingressmodule = _x;
                };
                case (typeOf _x == "HEDES_MissionModule_TASK"): {
                    _missiontaskmodules pushBack _x;
                };
            };
        } forEach (synchronizedObjects _x);
        
        if (_randomize) then
        {
            private _rnd = floor random[0,_maxtasks/2,_maxtasks];
            private _newtaskarray = [];
            while {count(_newtaskarray) <= _rnd} do
            {
                _newtaskarray pushback (selectRandom _missiontaskmodules);
            };
            _missiontaskmodules = _newtaskarray;
        };

        _missionlist pushBack [_hqmodule, _deploymodule, _ingressmodule, _missionmodule, _missiontaskmodules];

    } forEach _missionmanagers;

    // -- Add Mission System dialog to NPC
    {
        [
            _x,
            [
                "Open Mission dialog",
                {
                    _logic = _this select 3 select 0;
                    _missionlist = _this select 3 select 1;
                    
                    [_logic, _missionlist] spawn FUNC(ShowAvailableMissions);
                },
                [_logic,_missionlist],
                1.5,
                true,
                false,
                "",
                "player == leader(group player)", 5
            ]
        ] remoteExec ["addAction",0,true];
    } forEach _missiongivers;

    // -- Interval Between Refresh
    sleep (call compile _refreshtime);

    // -- Remove Action
    {
        [_x] remoteExec ["removeAllActions",0,true];
    } forEach _missiongivers;
};
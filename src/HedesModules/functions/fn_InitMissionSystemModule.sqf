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
if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];
private _missiongiver = synchronizedObjects _logic select {_x isKindOf "Man"} select 0;
private _randomize = _logic getVariable "MissionGiverRandomize";
private _refreshtime = _logic getVariable ["MissionGiverRefresh","360"];

// -- Add Mission Giver Nameplates
private _drawnameplatercmd = { 
    private _newvarr = missionNamespace getVariable ["HEDESMISSIONGIVERS",[]];
    missionNamespace setVariable ["HEDESMISSIONGIVERS",_newvarr + [_this]];
    [] spawn {
        while{true}do
        {
            missionNamespace setVariable [
                "DRAWMISSIONGIVERS",
                player nearEntities["Man",20] select {_x in (missionNamespace getVariable "HEDESMISSIONGIVERS")}
            ];
            sleep 1;
        };        
    };
    addMissionEventHandler ["Draw3D", { 
        { 
            drawIcon3D ["", [1,1,1,1], visiblePosition _x vectorAdd [0,0,2], 0.6, 0.6, 45, format ["%1 (Missions)", name _x], 2, 0.04, "PuristaSemiBold"]; 
        } foreach (missionNamespace getVariable ["DRAWMISSIONGIVERS",[]])
    }];
};
[_missiongiver,_drawnameplatercmd] remoteExec ["BIS_fnc_call", 0, true];

// -- Periodically Change 
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
        private _rnd = ceil random[0,_rndmid, _rndmax];
        
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
        private _deploymodule = objNull;
        private _ingressmodule = objNull;
        private _missionmodule = _x;    
        private _maxtasks = 5;

        private _missiontaskmodules = [];
        
        {        
            switch (true) do
            {
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
            private _rnd = ceil random[0,_maxtasks/2,_maxtasks];
            private _newtaskarray = [];
            while {count(_newtaskarray) <= _rnd} do
            {
                _newtaskarray pushback (selectRandom _missiontaskmodules);
            };
            _missiontaskmodules = _newtaskarray;
        };

        _missionlist pushBack [_deploymodule, _ingressmodule, _missionmodule, _missiontaskmodules];

    } forEach _missionmanagers;

    // -- Add Mission System dialog to NPC
    [
        _missiongiver,
        [
            "Open Mission dialog",
            {
                _logic = _this select 3 select 0;
                _missionlist = _this select 3 select 1;
                _missiongiver = _this select 3 select 2;
                
                [_logic, _missionlist, _missiongiver] spawn FUNC(ShowAvailableMissions);
            },
            [_logic,_missionlist,_missiongiver],
            1.5,
            true,
            false,
            "",
            "player == leader(group player)", 5
        ]
    ] remoteExec ["addAction",0,false];

    // -- Interval Between Refresh
    sleep (call compile _refreshtime);

    // -- Remove Action
    [_missiongiver] remoteExec ["removeAllActions",0,false];
};
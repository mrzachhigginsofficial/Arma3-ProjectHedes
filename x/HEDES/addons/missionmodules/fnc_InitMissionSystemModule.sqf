/*
---------------------------------------------
Initializes The Mission System Module Server Side
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];
private _missionGiver = synchronizedObjects _logic select { _x isKindOf "MAN" } select 0;
private _missionObjs = synchronizedObjects _logic select { typeOf _x == "HEDES_Missionmodule_MANAGER" };

// Add Mission Giver To Draw Name Plate List For Clients
_missionGiver call FUNCMAIN(AppendMissionGiverNamePlates);

// Main Routine
[_logic,_missionGiver,_missionObjs] spawn {

    params["_logic","_missionGiver","_missionObjs"];

    while {true} do {        

        // Build Mission List To Be Passed Locally To Clients
        private _randomize = _logic getVariable ["MissionGiverRandomize",true];
        private _refreshTime = call compile (_logic getVariable ["MissionGiverRefresh","360"]);
        private _missionList = [];

        {
            private _deployModule = synchronizedObjects _x select {typeOf _x == "HEDES_MissionModule_DEPLOY"} select 0;
            private _ingressModule = synchronizedObjects _x select {typeOf _x == "HEDES_MissionModule_INGRESS"} select 0;
            private _allMissionTasks = synchronizedObjects _x select {typeOf _x == "HEDES_MissionModule_TASK"};
            private _missionTasks = if (_randomize && count(_missionObjs) > 1) then {
                    private _rnd = count(_missionObjs) call FUNCMAIN(MontanaRandomizer);
                    [_allMissionTasks, _rnd] call CBA_fnc_selectRandomArray
                } else {
                    _allMissionTasks
                };

            _missionList pushBack [_deployModule, _ingressModule, _x, _missionTasks];

        } foreach (if (_randomize && count(_missionObjs) > 1) then {
            // Randomize Missions Available On This Iteration
            private _rnd = count(_missionObjs) call FUNCMAIN(MontanaRandomizer);
            [_missionObjs, _rnd] call CBA_fnc_selectRandomArray
        } else {
            // No Randomization - Just Spawn The Missions
            _missionObjs
        });

        systemChat format["%1",_missionList];

        // Add Open Mission Action To Mission Giver 
        [
            _missionGiver,
            [
                "Open Mission Dialog",
                {
                    [
                        _this select 3 select 0, 
                        _this select 3 select 1,  
                        _this select 3 select 2
                    ] spawn FUNCMAIN(ShowAvailableMissions);
                },
                [_logic,_missionList,_missionGiver],
                1.5,
                true,
                false,
                "",
                "player == leader(group player)",
                5
            ]
        ] remoteExec ["addAction",0,true];

        sleep _refreshTime;

        // Remove All Actions (Refresh Mission List And Combo)
        [_missiongiver] remoteExec ["removeAllActions",0,true];
    };
};
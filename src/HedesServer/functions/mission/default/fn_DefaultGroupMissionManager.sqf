/* 
--------------------------------------------------------------------
Default Mission Manager. 

Description:
    This is the default mission manager that is used in the Project 
    Hedes mission manager framework.

Notes: 
    This script needs parameterized as much as possible...

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

private _player                 = param[0, player];
private _missionhqloc           = getPos (param[1, objNull]);
private _missiondeployloc       = getPos (param[2, objNull]);
private _missioningressloc      = getPos (param[3, objNull]);
private _missionegressloc       = getPos (param[3, objNull]);
private _missionmodule          = param[4, objNull];
private _missiontaskmodules     = param[5, [objNull]];

private _missiontype            = _missionmodule getVariable "Missiontype";
private _missionobject          = _missionmodule getVariable "MissionManagerObjecttype";

private _groupid                = netId (group _player);
private _groupstate             = [_groupid] call FUNC(GetplayerMissionState);

private _taskspawnargs = [
    [
        "O_G_Soldier_F",
        "O_G_Soldier_lite_F",
        "O_G_Soldier_SL_F",
        "O_G_Soldier_TL_F",
        "O_G_Soldier_AR_F",
        "O_G_medic_F",
        "O_G_engineer_F",
        "O_G_Soldier_exp_F",
        "O_G_Soldier_GL_F",
        "O_G_Soldier_M_F",
        "O_G_Soldier_LAT_F",
        "O_G_Soldier_A_F"
    ],
    5
];

if (_groupstate == 0) then {

    [_groupid, 1, _missiontype] call FUNC(setplayerMissionState);
    
    /* 
    ---------------------------------------------------------------
    Phase 1. Create Mission Deploy Task And Wait For Player Group
    ---------------------------------------------------------------
    */
        
    [group _player, _missiondeployloc] call FUNC(CreateMeetTask);
    
    /* 
    ---------------------------------------------------------------
    Phase 2. Camera Transition Out (Deploy Start)
    ---------------------------------------------------------------
    */

    {
        [_x, "fade", "", "Deploying..."] call FUNC(CompilePlayerTransitionCamera);
    } forEach (units(groupFromnetId _groupid) select {_x in allplayers});
    sleep 2;
    
    /* 
    ---------------------------------------------------------------
    Phase 3. Move Player And Show Cinematic Zoom Camera
    ---------------------------------------------------------------
    */

    {
        [_x, "zoom", "HQ", "Mission is a go..."] call FUNC(CompilePlayerTransitionCamera);
    } forEach (units(groupFromnetId _groupid) select {_x in allplayers});
    sleep 2;

    /* 
    ---------------------------------------------------------------
    Phase 4. Mark group As in Active Mission
    ---------------------------------------------------------------
    */

    [_groupid, 2, _missiontype] call FUNC(setplayerMissionState);
    missionNamespace setVariable [format["mission_%1_ingress",getPlayerUID _player], _missiondeployloc];
    missionNamespace setVariable [format["mission_%1_ingress",getPlayerUID _player], _missioningressloc];
    
    /* 
    ---------------------------------------------------------------
    Phase 5. Start executing and Tracking Tasks (Mission Loop)
    ---------------------------------------------------------------
    */

    {
        try{

            // -- Read Task Module Properties

            private _tasktype = _x getVariable "TaskType";
            private _tasktitl = _x getVariable "TaskName";
            private _taskdesc = _x getVariable "TaskDescription";
            
            private _createTaskfnc = "";
            private _createareafnc = "";
            private _checktaskfnc = "";
            
            switch (_missiontype) do
            {
                case("kill"): {
                    _createTaskfnc  = FUNC(CreateDestroyTask);
                    _createareafnc  = FUNC(SpawnObjectiveArea);
                    _checktaskfnc   = FUNC(CheckTask);
                };
                case("destroy"): {
                    _createTaskfnc  = FUNC(CreateDestroyTask);
                    _createareafnc  = FUNC(SpawnObjectiveArea);
                    _checktaskfnc   = FUNC(CheckTask);
                };
            };
            
            // -- Run Create Task Function
            private _task = [_groupid, _missiontype, _tasktitl, _taskdesc] call _createTaskfnc;
            
            // -- Create Mission Task Objectives
            private _checktskargs = [_missiontype, _missionobject] + _task + [_taskspawnargs] call _createareafnc;
            
            // -- Apply Effects To Missions Objects
            [_checktskargs, _x] call FUNC(SetGroupSurrenderEffect);
            [_checktskargs, _x] call FUNC(SetObjectExplosion);
            
            // -- Add Task Objects to Tracking Mission Variable
            [_groupid, _checktskargs] call FUNC(AppendPlayerMissionObject);
            
            // -- Evaluate Task Status
            ([_groupid] + _checktskargs) call _checktaskfnc;
            
            // -- Delete Task
            [_task select 1] call BIS_fnc_deleteTask;
        }
        catch {
            echo _exception;
        };
        sleep 5;

    } forEach _missiontaskmodules;
    
    /* 
    ---------------------------------------------------------------
    FINAL PHASE 1. Create Meet Mission Task For Exfil
    ---------------------------------------------------------------
    */

    private _title = "Move to Extraction";
    private _desc = "move all group members to extraction area to end mission.";
    [group _player, _missiondeployloc,_title,_desc] call FUNC(CreateMeetTask);

    /* 
    ---------------------------------------------------------------
    FINAL PHASE 2. Camera Transition Out of Mission
    ---------------------------------------------------------------
    */

    {
        [_x, "fade", "", "Returning to base..."] call FUNC(CompilePlayerTransitionCamera);
    } forEach (units(groupFromnetId _groupid) select {_x in allplayers});
    sleep 2;
    
    /* 
    ---------------------------------------------------------------
    FINAL PHASE 3. Move Player & Camera Zoom Down
    ---------------------------------------------------------------
    */

    {
        [_x, "zoom", "", ""] call FUNC(CompilePlayerTransitionCamera);
    } forEach (units(groupFromnetId _groupid) select {_x in allplayers});
    sleep 2;
    
    /* 
    ---------------------------------------------------------------
    CLEANUP PHASE - MISSION OVER
    ---------------------------------------------------------------
    */

    private _leftovers = [_groupid] call FUNC(GetplayerMissionObjects);
    _leftovers call FUNC(SpawnObjectCleanupThread);
    
    [_groupid, 0, _missiontype] call FUNC(setplayerMissionState);
    [_endMissionTask] call BIS_fnc_deleteTask;
};
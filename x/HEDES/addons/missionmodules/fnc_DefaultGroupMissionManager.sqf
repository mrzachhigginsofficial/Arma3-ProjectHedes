/*
---------------------------------------------
Default Mission Manager
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _player                 = param[0, player];
private _missiondeployloc       = getPos (param[1, objNull]);
private _missioningressloc      = getPos (param[2, objNull]);
private _missionmodule          = param[3, objNull];
private _missiontaskmodules     = param[4, [objNull]];

private _missiontype            = _missionmodule getVariable "Missiontype";
private _missionobject          = _missionmodule getVariable "MissionManagerObjecttype";
private _missionaccomplished    = true;

private _groupmissionobjects    = [];
private _groupid                = netId (group _player);
private _groupstatedata         = [QGVAR(MISSIONSTATES),missionNamespace] call FUNCMAIN(GetData);
private _groupstate             = [_groupstatedata,_groupid] call CBA_fnc_hashGet;

ISNILS(_groupstate,0);

private _compilefnc = {
    private _params = param[0];
    private _function = param[1];    
    call compile format["%1 call %2", _params, _function];
};

private _missioncamaccomplished = {
    playmusic "EventTrack01_F_Curator";
    cutText ["<t color='#A7FFA4' size='5'>MISSION ACCOMPLISHED</t>", "PLAIN DOWN", 2, true, true]; 
};

private _missioncamfailed = {
    playmusic "EventTrack02_F_Curator";
    cutText ["<t color='#FF0000' size='5'>MISSION FAILED</t>", "PLAIN DOWN", 2, true, true]; 
};


if (_groupstate == 0) then {
    
    [_groupstatedata, _groupid, 1] call CBA_fnc_hashSet;
    
    /* 
    ---------------------------------------------------------------
    Phase 1. Create Mission Deploy Task And Wait For Player Group
    ---------------------------------------------------------------
    */
        
    [group _player, _missiondeployloc] call FUNCMAIN(CreateMeetTask);

    /* 
    ---------------------------------------------------------------
    Phase 2. Mark group As in Active Mission
    ---------------------------------------------------------------
    */

    [_groupstatedata, _groupid, 2] call CBA_fnc_hashSet;
    
    /* 
    ---------------------------------------------------------------
    Phase 3. Start executing and Tracking Tasks (Mission Loop)
    ---------------------------------------------------------------
    */

    {
        try{

            // Read Task Module Properties

            private _tasktype = _x getVariable "TaskType";
            private _tasktitl = _x getVariable "TaskName";
            private _taskdesc = _x getVariable "TaskDescription";
            private _unitpool = (synchronizedObjects _x select {typeOf _x == "HEDES_GenericModule_UNITPOOL"}
                select 0) getVariable "UnitPool";
            
            private _createTaskfnc  = {};
            private _createareafnc  = {};
            private _checktaskfnc   = {};

            switch (_tasktype) do
            {
                case "destroy": {
                    _createTaskfnc  = FUNCMAIN(CreateDestroyTask);
                    _createareafnc  = FUNCMAIN(SpawnDestroyObjective);
                    _checktaskfnc   = FUNCMAIN(CheckDestroyTask);
                };
                case "assassinate": {
                    _createTaskfnc  = FUNCMAIN(CreateAssassinateTask);
                    _createareafnc  = FUNCMAIN(SpawnAssassinateObjective);
                    _checktaskfnc   = FUNCMAIN(CheckAssassinateTask);                    
                };
            };
            
            // Run Create Task Function
            private _task = [_groupid, _missiontype, _tasktitl, _taskdesc] call _createTaskfnc;
            
            // Create Mission Task Objectives
            private _aoobjs = ([_missionobject] + [_task # 0] + [[_unitpool,5]]) call _createareafnc;
            
            // Apply Effects To Missions Objects
            private _effects = synchronizedObjects _x select { typeOf _x == "HEDES_MissionModule_TASKEFFECT" };
            if (count(_effects) > 0) then 
            {
                _effects apply {
                    [_aoobjs, _x getVariable "EffectType"] call _compilefnc;
                };
            };
            
            // Add Task Objects to Tracking Mission Variable
            _groupmissionobjects append _aoobjs;
            
            // Evaluate Task Status
            ([_groupid] + _aoobjs) call _checktaskfnc;
            
            // Delete Task
            [_task select 1] call BIS_fnc_deleteTask;
        }
        catch {
            echo _exception;
        };
        sleep 1;

    } forEach _missiontaskmodules;
    
    
    /* 
    ---------------------------------------------------------------
    CLEANUP PHASE - MISSION OVER
    ---------------------------------------------------------------
    */

    // Reward Phase
    [_groupstatedata, _groupid, 0] call CBA_fnc_hashSet;

    if (_missionaccomplished) then {
        _missioncamaccomplished remoteExec ["BIS_fnc_call",groupFromNetId _groupid];
    } else {
        _missionfailed remoteExec ["BIS_fnc_call",groupFromNetId _groupid];
    };

    // Cleanup Phase
    _groupmissionobjects call FUNCMAIN(AppendCleanupSystemObjects);
};

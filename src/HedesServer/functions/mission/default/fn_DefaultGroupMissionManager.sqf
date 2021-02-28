// -- [_player,_hqmodule,_deploymodule,_ingressmodule,_missiontype] call HEDESServer_fnc_DefaultMissionManager;

private _player = param [0, player];
private _missionhqloc = getPos (param[1, objNull]);
private _missiondeployloc = getPos (param[2, objNull]);
private _missioningressloc = getPos (param[3, objNull]);
private _missionegressloc = getPos (param[3, objNull]);
private _missiontype = param [4, "default"];
private _missionobject = param[5, "Land_CratesWooden_F"];

// load Basic Mission parameters
private _groupid = netId (group _player);
private _trackervarname = gettext(configFile >> "CfgHedesMissions" >> "playermissiontrackerglobal");
private _getmissionstatefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionstategetterfnc");


HEDES_COMPILE_FUNCTION_CMD = {
    private _params = param[0];
    private _function = param[1];

    call compile format["%1 call %2",_params,_function];
};


if (!([[_groupid, _trackervarname],_getmissionstatefnc] call HEDES_COMPILE_FUNCTION_CMD)) then {
    
    // -1. Prepare Mission parameters
    private _playermissionstatesetterfnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionstatesetterfnc");
    private _compileplayertransitioncamfnc = gettext(configFile >> "CfgHedesSessionManagers" >> "compileplayertransitioncamfnc");
    private _appendplayermissionobjectfnc = gettext(configFile >> "CfgHedesMissions" >> "appendplayermissionobjectfnc");
    private _playermissionobjectsgetfnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionobjectsgetfnc");
    private _cleanupmissionplayerobjectfnc = gettext(configFile >> "CfgHedesMissions" >> "cleanupmissionplayerobjectfnc");
    private _tasktitl = gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "tasktitl");
    private _taskdesc = gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "taskdesc");
    private _tasks = getArray(configFile >> "CfgHedesMissions" >> _missiontype >> "tasks");
    private _taskeffectsfnc = getArray(configFile >> "CfgHedesMissions" >> _missiontype >> "taskeffectsfnc");
    private _taskspawnargs = [configFile >> "CfgHedesMissions" >> _missiontype, "taskspawnargs"] call HEDESServer_fnc_GetMissionArgProperties;
    private _missionDifficultymultiplier = getNumber(configFile >> "CfgHedesMissions" >> _missiontype >> "missionDifficultymultiplier");
    private _missionmaxenemysquads = getNumber(configFile >> "CfgHedesMissions" >> _missiontype >> "missionmaxenemysquads") * _missionDifficultymultiplier;
    
    // 1. Create Mission Deploy Task
    [[_groupid, '1', _missiontype,_trackervarname],_playermissionstatesetterfnc] call HEDES_COMPILE_FUNCTION_CMD;
    private _missionTask = format["%1_beginmissiontask", _groupid];
    private _deploytasktitle = "Begin Mission";
    private _deploytaskdesc = "move all players in squad to marker to begin mission.";
    private _markername = "cookiemarker";    
    [groupFromnetId _groupid, [_missionTask], [_deploytaskdesc, _deploytasktitle, _markername], _missiondeployloc, 1, 2, true] call BIS_fnc_taskCreate;
    while {
        count (units (groupFromnetId _groupid) select {
            _x in allplayers
        } select {
            _x distance _missiondeployloc > 10
        }) > 0
    } do
    {
        sleep 1;
    };
    [_missionTask] call BIS_fnc_deleteTask;
    
    // 2. Camera Transition Out (Deploy Start)
    {
        [[_missiontype, 'deploycam', owner _x],_compileplayertransitioncamfnc] call HEDES_COMPILE_FUNCTION_CMD;
    } forEach (units(groupFromnetId _groupid) select {
        _x in allplayers
    });
    sleep 2;
    
    // 3. move group to Mission AO
    {
        _x setPos _missioningressloc;
        [[_missiontype, 'missionstartcam', owner _x],_compileplayertransitioncamfnc] call HEDES_COMPILE_FUNCTION_CMD;
    } forEach (units(groupFromnetId _groupid) select {
        _x in allplayers
    });
    
    // 4. Mark group As in Active Mission
    [[_groupid, '2', _missiontype,_trackervarname],_playermissionstatesetterfnc] call HEDES_COMPILE_FUNCTION_CMD;
    
    // 5. Start executing and Tracking Tasks
    {
        try{
            private _createTaskfnc = _x select 0;
            private _spawnobjfnc = _x select 1;
            private _checktaskfnc = _x select 2;
            
            // Create Task
            private _task = [[_groupid, _missiontype, _tasktitl, _taskdesc], _createTaskfnc] call HEDES_COMPILE_FUNCTION_CMD;
            
            // Create Task Obj
            private _checktskargs = [[_missiontype,_missionobject] + _task + [_taskspawnargs], _spawnobjfnc] call HEDES_COMPILE_FUNCTION_CMD;
            
            // apply Effects
            {
                [_checktskargs, _x] call HEDES_COMPILE_FUNCTION_CMD;
            } forEach _taskeffectsfnc;
            
            // Add Task Objects to Tracking Mission Variable
            [[_groupid, _trackervarname, _checktskargs], _appendplayermissionobjectfnc] call HEDES_COMPILE_FUNCTION_CMD;
            
            // Evaluate Task Status
            [[_groupid] + _checktskargs, _checktaskfnc] call HEDES_COMPILE_FUNCTION_CMD;
            
            // Delete Task
            [_task select 1] call BIS_fnc_deleteTask;
        }
        catch {
            systemChat _exception;
        };
        sleep 5;
    } forEach _tasks;
    
    // Final - Extraction (Mission End)
    private _endMissionTask = format["%1_endMissiontask", _groupid];
    private _extracttasktitle = "move to Extraction";
    private _extracttaskdesc = "move all group members to extraction area to end mission.";
    [groupFromnetId _groupid, [_endMissionTask], [_extracttaskdesc, _extracttasktitle, _markername], _missionegressloc, 1, 2, true] call BIS_fnc_taskCreate;
    while {
        count (units (groupFromnetId _groupid) select {
            _x in allplayers
        } select {
            _x distance _missionegressloc > 10
        }) > 0
    } do
    {
        sleep 1;
    };
    
    // Final - Transition Out of Mission
    {
        [[_missiontype,'finishedcam', owner _x], _compileplayertransitioncamfnc] call HEDES_COMPILE_FUNCTION_CMD;
    } forEach (units(groupFromnetId _groupid) select {
        _x in allplayers
    });
    sleep 2;
    
    // Final - move group Back to HQ
    {
        _x setPos _missionhqloc;
        [[_missiontype,'returncam', owner _x], _compileplayertransitioncamfnc] call HEDES_COMPILE_FUNCTION_CMD;
    } forEach (units(groupFromnetId _groupid) select {
        _x in allplayers
    });
    
    // Cleanup
    private _leftovers = [[_groupid, _trackervarname],_playermissionobjectsgetfnc] call HEDES_COMPILE_FUNCTION_CMD;
    [_leftovers,_cleanupmissionplayerobjectfnc] call HEDES_COMPILE_FUNCTION_CMD;
    
    [[_groupid, '0', _missiontype,_trackervarname],_playermissionstatesetterfnc] call HEDES_COMPILE_FUNCTION_CMD;
    [_endMissionTask] call BIS_fnc_deleteTask;
};
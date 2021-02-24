private _player = param [0, player];
private _missiontype = param [1, "default"];

// load Basic Mission parameters
private _groupid = netid (group _player);
private _trackervarname = gettext(configFile >> "CfgHedesMissions" >> "playermissiontrackerglobal");
private _getmissionstatefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionstategetterfnc");
private _getplayerinmissioncmd = format["['%1', '%2'] call %3", _groupid, _trackervarname, _getmissionstatefnc];

if (!(call compile _getplayerinmissioncmd)) then {
    
    // -1. Prepare Mission parameters
    private _deployobj = nearestobject [leader(groupFromNetId _groupid), gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "missiondeployobjtype")];
    private _setmissionstatefnc = gettext(configFile >> "CfgHedesMissions" >> "playermissionstatesetterfnc");
    private _ingresexpression = gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "missiondingressambientexpre");
    private _taskmultiplier = getNumber(configFile >> "CfgHedesMissions" >> _missiontype >> "missionDifficultymultiplier");
    private _tasklength = getNumber(configFile >> "CfgHedesMissions" >> _missiontype >> "missionmaxenemysquads") * _taskmultiplier;
    private _missionaoargs = [configFile >> "CfgHedesMissions" >> _missiontype, "missiontargetareaargs"] call HEDESServer_fnc_GetMissionArgProperties;
    private _missionhqargs = [configFile >> "CfgHedesMissions" >> _missiontype, "missionhqargs"] call HEDESServer_fnc_GetMissionArgProperties;
    private _taskarray = getArray(configFile >> "CfgHedesMissions" >> _missiontype >> "tasks");
    private _taskeffects = getArray(configFile >> "CfgHedesMissions" >> _missiontype >> "taskeffectsfnc");
    
    // -1. Prepare compiled Commands
    private _setplayeroutofmissioncmd = format["['%1', 0, '%2', '%3'] call %4", _groupid, _missiontype, _trackervarname, _setmissionstatefnc];
    private _setplayerstartingmissioncmd = format["['%1', 1, '%2', '%3'] call %4", _groupid, _missiontype, _trackervarname, _setmissionstatefnc];
    private _setplayerinmissioncmd = format["['%1', 2, '%2', '%3'] call %4", _groupid, _missiontype, _trackervarname, _setmissionstatefnc];
    private _ingresspos = call compile format["%2 call %1", "HEDESServer_fnc_GetLocationPosByname", _missionaoargs];
    private _hqposition = call compile format["%2 call %1", "HEDESServer_fnc_GetLocationPosByname", _missionhqargs];
    
    // 1. Create Mission Deploy Task
    call compile _setplayerstartingmissioncmd;
    private _missionTask = format["%1_beginmissiontask", _groupid];
    private _deploytasktitle = "Begin Mission";
    private _deploytaskdesc = "Move all players in squad to marker to begin mission.";
    private _markername = "cookiemarker";
    [groupFromNetId _groupid, [_missionTask], [_deploytaskdesc, _deploytasktitle, _markername], (getPos _deployobj), 1, 2, true] call BIS_fnc_taskCreate;
    while {
        count (units (groupFromNetId _groupid) select {_x in allPlayers} select {
            _x distance (getPos _deployobj) > 10
        }) > 0
    } do
    {
        sleep 1;
    };
    [_missionTask] call BIS_fnc_deleteTask;
    
    // 2. Camera Transition Out (Deploy Start)
    {
        [_missiontype, "deploycam", owner _x] call HEDESServer_fnc_compileplayerTransitionCamera;
    } forEach (units(groupFromNetId _groupid) select {_x in allPlayers});
    sleep 2;
    
    // 3. move group to Mission AO
    {
        _x setPos (selectRandom(selectBestPlaces [_ingresspos, 50, _ingresexpression, 1, 5]) select 0);
        [_missiontype, "missionStartcam", owner _x] call HEDESServer_fnc_compileplayerTransitionCamera;
    } forEach (units(groupFromNetId _groupid) select {_x in allPlayers});
    
    // 4. Mark group As in Active Mission
    call compile _setplayerinmissioncmd;
    
    // 5. Start executing and Tracking Tasks
    {
        try{
            private _createTaskfnc = _x select 0;
            private _spawnobjfnc = _x select 1;
            private _checktaskfnc = _x select 2;
            
            // Create Task
            private _task = call compile format["['%1'] call %2", _groupid, _createTaskfnc];
            private _taskposition = _task select 0;
            private _taskname = _task select 1;
            
            // Create Task Obj
            private _taskspawnargs = [configFile >> "CfgHedesMissions" >> _missiontype, "taskspawnargs"] call HEDESServer_fnc_GetMissionArgProperties;
            _taskspawnargs pushBack _taskposition;
            private _checktskargs = call compile format["%1 call %2", _taskspawnargs, _spawnobjfnc];
            
            // Apply Effects
            {
                call compile format["%1 call %2", _checktskargs, _x];
            } forEach _taskeffects;
            
            // Add Task Objects to Tracking Mission Variable
            ([_groupid, _trackervarname, _checktskargs]) call HEDESServer_fnc_AppendPlayerMissionObject;
            
            // Evaluate Task Status
            _checktskargs pushBack _groupid;
            call compile format["%1 call %2", _checktskargs, _checktaskfnc];
            
            // Delete Task
            [_taskname] call BIS_fnc_deleteTask;
        }
        catch {
            echo _exception;
        };
        sleep 5;
    } forEach _taskarray;
    
    // Final - Extraction (Mission End)
    private _endMissionTask = format["%1_endMissiontask", _groupid];
    private _extracttasktitle = "Move to Extraction";
    private _extracttaskdesc = "Move all group members to extraction area to end mission.";
    private _extractobj = nearestobject [_ingresspos, gettext(configFile >> "CfgHedesMissions" >> _missiontype >> "missionextractobjtype")];
    [groupFromNetId _groupid, [_endMissionTask], [_extracttaskdesc, _extracttasktitle, _markername], (getPos _extractobj), 1, 2, true] call BIS_fnc_taskCreate;
    while {
        count (units (groupFromNetId _groupid) select {_x in allPlayers} select {
            _x distance (getPos _extractobj) > 10
        }) > 0
    } do
    {
        sleep 1;
    };
    
    // Final - Transition Out of Mission
    {
        [_missiontype, "finishedcam", owner _x] call HEDESServer_fnc_compileplayerTransitionCamera;
    } forEach (units(groupFromNetId _groupid) select {_x in allPlayers});
    sleep 2;
    
    // Final - move group Back to HQ
    {
        _x setPos (selectRandom(selectBestPlaces [_hqposition, 50, _ingresexpression, 1, 5]) select 0);
        [_missiontype, "returncam", owner _x] call HEDESServer_fnc_compileplayerTransitionCamera;
    } forEach (units(groupFromNetId _groupid) select {_x in allPlayers});
    
    call compile _setplayeroutofmissioncmd;
    [_endMissionTask] call BIS_fnc_deleteTask;
};
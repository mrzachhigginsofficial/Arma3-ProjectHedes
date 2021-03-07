/* 
--------------------------------------------------------------------
Show Available Missions GUI

Description:
    Shows the available missions GUI for specific NPC. Action to
    execute this script clientside is added through 
    initmissionsystemmodule.sqf (executed from server).

Notes: 

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "..\macros.h"
#include "..\defines.h"
if (!isServer) exitWith {};

private _logic          = param[0, objNull];
private _missionlist    = param[1, []];
private _missiongiver    = param[2, objNull];

createdialog "HEDES_MissionGiverdialog";

waitUntil {
    !isNull (uiNamespace getVariable "HEDES_MissionGiverdialog")
};

private _guiwindow = uiNamespace getVariable "HEDES_MissionGiverdialog";
private _dialog_name = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_NAME;
private _dialog_avatar = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_AVATAR;
private _dialog_missions = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_LISTBOX;
private _dialog_missiondesc = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_DESCRIPTION;
private _dialog_OKbutton = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_OKBTN;
private _dialog_Cancelbutton = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_CANCELBTN;

_dialog_name ctrlsettext (name _missiongiver);
_dialog_avatar ctrlsettext (_logic getVariable "MissionGiverAvatar");
_dialog_missiondesc ctrlSetText "Select a mission";

HEDESMissionDialogCode_LBelect = {
    params ["_control", "_index"];
    private _guiwindow 	= uiNamespace getVariable "HEDES_MissionGiverdialog";
    private _dialog_missiondesc = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_DESCRIPTION;

    private _varname = format["HEDESMissionData_%1", _index];
    private _mission = missionnamespace getVariable _varname;
    
    private _missionmodule = _mission select 2;
    private _missiontaskmodules = _mission select 3;
    
    private _taskDescriptions = [];
    private _taskdesc = "";
    private _index = 0;
    {
        _index = _index + 1;
        private _tasktype = _x getVariable ["tasktype", ""];
        private _taskname = _x getVariable ["Taskname", ""];
        private _taskdesc = _x getVariable ["taskDescription", ""];

        private _icon = "";
        switch (_tasktype) do
        {
            case "destroy" : {_icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa";};
            case "assassinate" : {_icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\kill_ca.paa";};
            case "kill" : {_icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa";};
        };           
            
        _taskDescriptions pushBack format["%1.) <img image='%2'/> %3: %4", _index, _icon, _taskname, _taskdesc];

    } forEach _missiontaskmodules;
    
    private _missiondescription = format[
        "%1 <br/><br/><t size='1'>You have %2 tasks. Here's the job:</t>", _missionmodule getVariable "MissionDescription", count(_missiontaskmodules)
        ];
    
    _dialog_missiondesc ctrlsetstructuredtext parsetext 
        ([_missiondescription, _taskDescriptions joinstring "<br/>"] joinstring "<br/><br/>");

    _dialog_missiondesc ctrlSetPositionH ((ctrlTextHeight _dialog_missiondesc) * 1);
    _dialog_missiondesc ctrlCommit 0;
};

HEDESMissionDialogEvent_LBselect = _dialog_missions ctrlAddEventHandler ["LBSelChanged", HEDESMissionDialogCode_LBelect];

HEDESMissionDialogEvent_OKBUTTON = _dialog_OKbutton ctrlAddEventHandler ["ButtonClick", {
	closedialog 2;
    private _guiwindow 	= uiNamespace getVariable "HEDES_MissionGiverdialog";
    private _dialog_missions = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_LISTBOX;
	private _dialog_OKbutton = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_OKBTN;
	private _dialog_Cancelbutton = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_CANCELBTN;    
    private _index = lbCurSel _dialog_missions;
    private _varname = format["HEDESMissionData_%1", _index];
    private _mission = missionnamespace getVariable _varname;
    
    ([player] + _mission) remoteExec [QUOTE(FUNC(defaultgroupMissionManager)), 2];

    _dialog_missions ctrlremoveEventHandler ["LBSelChanged", HEDESMissionDialogEvent_LBselect];
	_dialog_OKbutton  ctrlremoveEventHandler ["onButtonClick", HEDESMissionDialogEvent_OKBUTTON];
	_dialog_Cancelbutton  ctrlremoveEventHandler ["onButtonClick", HEDESMissionDialogEvent_CANCELBUTTON];
}];

HEDESMissionDialogEvent_CANCELBUTTON = _dialog_Cancelbutton ctrlAddEventHandler ["ButtonClick", {
    closedialog 2;
    private _guiwindow 	= uiNamespace getVariable "HEDES_MissionGiverdialog";
    private _dialog_missions = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_LISTBOX;
	private _dialog_OKbutton = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_OKBTN;
	private _dialog_Cancelbutton = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_CANCELBTN;
    
    _dialog_missions ctrlremoveEventHandler ["LBSelChanged", HEDESMissionDialogEvent_LBselect];
	_dialog_OKbutton  ctrlremoveEventHandler ["onButtonClick", HEDESMissionDialogEvent_OKBUTTON];
	_dialog_Cancelbutton  ctrlremoveEventHandler ["onButtonClick", HEDESMissionDialogEvent_CANCELBUTTON];
}];

{
    private _name = (_x select 2) getVariable "missionname";
    private _index = _dialog_missions lbAdd _name;
    private _varname = format["HEDESMissionData_%1", _index];
    _dialog_missions lbsetData [_index, _varname];
    missionnamespace setVariable [_varname, _x];
} forEach _missionlist;

_dialog_missions lbSetCurSel 0;
[objNull, 0] call HEDESMissionDialogCode_LBelect;
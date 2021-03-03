/* 
--------------------------------------------------------------------
Show Available Missions GUI

Description:
    Shows the available missions GUI for specific NPC. Action is 
    added through initmissionsystemmodule.sqf

Notes: 
    This script needs parameterized as much as possible...

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "..\macros.h"
#include "..\defines.h"

private _logic          = param[0, objNull];
private _missionlist    = param[1, []];

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

_dialog_name ctrlsettext (_logic getVariable "MissionGivername");
_dialog_avatar ctrlsettext (_logic getVariable "MissionGiverAvatar");
_dialog_missiondesc ctrlSetText "Select a mission";

HEDESMissionDialogCode_LBelect = {
    params ["_control", "_index"];
    private _guiwindow 	= uiNamespace getVariable "HEDES_MissionGiverdialog";
    private _dialog_missiondesc = _guiwindow displayCtrl HEDESGUI_MISSIONDIALOG_DESCRIPTION;
    private _varname = format["HEDESMissionData_%1", _index];
    private _mission = missionnamespace getVariable _varname;
    
    private _missionmodule = _mission select 3;
    private _missiontaskmodules = _mission select 4;
    
    private _taskDescriptions = [];
    private _taskdesc = "";
    private _index = 0;
    {
        private _index = _index + 1;
        private _tasktype = _x getVariable ["tasktype", ""];
        private _taskname = _x getVariable ["Taskname", ""];
        private _taskdesc = _x getVariable ["taskDescription", ""];
        _taskDescriptions pushBack format["%1.) [%2] %3:<br/> %4", _index, _tasktype, _taskname, _taskdesc];
    } forEach _missiontaskmodules;
    
    private _missiondescription = format["%1 <br/><br/>You have %2 tasks. Here's the job...", _missionmodule getVariable "MissionDescription", count(_missiontaskmodules)];
    _taskdesc = _taskDescriptions joinstring "<br/><br/>";
    
    _dialog_missiondesc ctrlsetstructuredtext parsetext ([_missiondescription, _taskdesc] joinstring "<br/><br/>");
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
    
    ([player] + _mission) remoteExec ["HEDESServer_fnc_defaultgroupMissionManager", 2];

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
    private _name = (_x select 3) getVariable "missionname";
    private _index = _dialog_missions lbAdd _name;
    private _varname = format["HEDESMissionData_%1", _index];
    _dialog_missions lbsetData [_index, _varname];
    missionnamespace setVariable [_varname, _x];
} forEach _missionlist;

_dialog_missions lbSetCurSel 0;
[objNull, 0] call HEDESMissionDialogCode_LBelect;
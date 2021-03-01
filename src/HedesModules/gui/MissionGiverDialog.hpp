#include "..\defines.h"

class HEDES_MissionGiverDialog
{
	idd = -1;
	enableSimulation = 1;
	enableDisplay = 1;
	movingEnable = true;
	duration = 99999;
	name="HEDES_MissionGiverDialog";
	onLoad = "with uiNameSpace do { HEDES_MissionGiverDialog = _this select 0 }";

	class controls
	{
		class Background: RscText
		{
			idc = HEDESGUI_MISSIONDIALOG_BACKGROUND;
			x = 4 * GUI_GRID_W + GUI_GRID_X;
			y = 3.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 32 * GUI_GRID_W;
			h = 20 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
		};

		class MissionAccept: RscButton
		{
			idc = HEDESGUI_MISSIONDIALOG_OKBTN;
			x = 25.5 * GUI_GRID_W + GUI_GRID_X;
			y = 22 * GUI_GRID_H + GUI_GRID_Y;
			w = 10 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			text = "Accept";
		};
		class MissionCancel: RscButton
		{
			idc = HEDESGUI_MISSIONDIALOG_CANCELBTN;
			x = 5 * GUI_GRID_W + GUI_GRID_X;
			y = 22 * GUI_GRID_H + GUI_GRID_Y;
			w = 10 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			text = "Decline";
		};
		class MissionGiverAvatar: RscPicture
		{
			idc = HEDESGUI_MISSIONDIALOG_AVATAR;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 5 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 4 * GUI_GRID_H;
		};
		class MissionGiverName: RscText
		{
			idc = HEDESGUI_MISSIONDIALOG_NAME;
			text = "Mission Giver Name";
			x = 9.5 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 21 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorText[] = {1,1,1,1};
			sizeEx = 2 * GUI_GRID_H;
		};
		class MissionGiverDialog: RscText
		{
			idc = HEDESGUI_MISSIONDIALOG_DIALOG;
			text = """Hey, I got a couple things I need done. Interested?""";
			x = 9.5 * GUI_GRID_W + GUI_GRID_X;
			y = 5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 26 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
		};
		class TitleBar: RscText
		{
			idc = HEDESGUI_MISSIONDIALOG_TITLEBAR;
			x = 4 * GUI_GRID_W + GUI_GRID_X;
			y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 32 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1};
		};
		class SelectMission: RscListbox
		{
			idc = HEDESGUI_MISSIONDIALOG_LISTBOX;
			x = 25.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9 * GUI_GRID_H + GUI_GRID_Y;
			w = 10 * GUI_GRID_W;
			h = 12 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
		};
		class MissionDescription: RscStructuredText
		{
			idc = HEDESGUI_MISSIONDIALOG_DESCRIPTION;
			x = 5 * GUI_GRID_W + GUI_GRID_X;
			y = 9 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 12 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
		};
	};
};

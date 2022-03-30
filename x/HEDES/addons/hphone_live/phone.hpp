////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by zachh, v1.063, #Rivoso)
////////////////////////////////////////////////////////

/* #Rivoso
$[
	1.063,
	["hphone",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1600,"",[1,"OK",["0.396875 * safezoneW + safezoneX","0.522 * safezoneH + safezoneY","0.04125 * safezoneW","0.055 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1000,"",[1,"This is a test window.",["0.396875 * safezoneW + safezoneX","0.456 * safezoneH + safezoneY","0.2 * safezoneW","0.055 * safezoneH"],[0,0,0,1],[1,1,1,1],[-1,-1,-1,-1],"","-1"],[]]
]
*/

import RscPicture;
import RscStructuredText;

class hphone
{
	idd = 1000;
	enableSimulation = 1;
	enableDisplay = 1;
	movingEnable = true;

	class Controls
	{
		class RscPicture_1602: RscPicture
		{
			idc = 1602;
			text = "\x\HEDES\addons\hphone\hphone_rugged_1024.paa";
			x = 0.5 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = .45 * safezoneW;
			h = .70 * safezoneH;
		};
		class RscStructuredText_1603: RscStructuredText
		{
			idc = 1603;
			type = 13;
			text = "hPhone Diagnostics Initializing...<br/>...<br/>...<br/>This is a test.";
			x = 0.6620 * safezoneW + safezoneX;
			y = 0.285 * safezoneH + safezoneY;
			w = .115 * safezoneW;
			h = .32 * safezoneH;
			size = .03;
			colorBackground[] = { 1, 1, 1, .1 };
			
			class Attributes
			{
				font = "TahomaB";
				color = "#ffffff";
				colorLink = "#D09B43";
				align = "left";
				shadow = 1;
			};
		};
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////

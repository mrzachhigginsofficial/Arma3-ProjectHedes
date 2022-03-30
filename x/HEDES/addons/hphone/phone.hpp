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
			text = "\x\HEDES\addons\hphone\hphone.paa";
			x = 0.3 * safezoneW + safezoneX;
			y = 0.1 * safezoneH + safezoneY;
			w = .3 * safezoneW;
			h = .5 * safezoneH;
		};
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////

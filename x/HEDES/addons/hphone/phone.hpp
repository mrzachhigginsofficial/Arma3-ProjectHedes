import RscPicture;
import RscStructuredText;
import RscButton;

class HEDES_hPhone
{
	enableSimulation = 1;
	enableDisplay = 1;
	movingEnable = true;

	name="HEDES_hPhone";
	onLoad = "with uiNameSpace do { HEDES_hPhone = _this select 0 }";

	class Controls
	{
		class 1500: RscPicture
		{
			idc = 1500;
			text = "\x\HEDES\addons\hphone\hphone_rugged_1024.paa";
			x = 0.5 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = .45 * safezoneW;
			h = .70 * safezoneH;
		};
	}
}

class app_admintelemetry
{
	enableSimulation = 1;
	enableDisplay = 1;
	movingEnable = true;

	name="HEDES_app_admintelemetry";
	onLoad = "with uiNameSpace do { HEDES_app_admintelemetry = _this select 0 }";

	class Controls
	{
		class RscButton_1601: RscButton
		{
			idc = 1601;
			text = "CLOSE APP";
			x = 0.6645 * safezoneW + safezoneX;
			y = 0.780 * safezoneH + safezoneY;
			w = .110 * safezoneW;
			h = .02 * safezoneH;
			sizeEx = .02;
			font = "EtelkaMonospacePro";
		};

		class RscStructuredText_1603: RscStructuredText
		{
			idc = 1603;
			type = 13;
			text = "";
			x = 0.6620 * safezoneW + safezoneX;
			y = 0.485 * safezoneH + safezoneY;
			w = .115 * safezoneW;
			h = .32 * safezoneH;
			size = .02;
			colorBackground[] = { 1, 1, 1, .1 };
			
			class Attributes
			{
				font = "EtelkaMonospacePro";
				color = "#ffffff";
				colorLink = "#D09B43";
				align = "left";
				shadow = 1;
			};
		};
	};
};
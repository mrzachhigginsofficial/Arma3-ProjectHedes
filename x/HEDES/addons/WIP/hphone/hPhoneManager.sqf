uiNameSpace setVariable ["HEDES_hPhone",  findDisplay 46 createDisplay "RscDisplayEmpty"];
uiNameSpace setVariable ["HEDES_hPhone_ActiveControls",[]];

HEDES_HPHONE_APPX = .18;
HEDES_HPHONE_APPY = .395;
HEDES_HPHONE_APPW = .13;
HEDES_HPHONE_APPH = .35;
HEDES_HPHONE_CLOSEBUTTONX = .2275;
HEDES_HPHONE_CLOSEBUTTONY = .75;
HEDES_HPHONE_CLOSEBUTTONW = .035;
HEDES_HPHONE_CLOSEBUTTONH = .058;


HEDES_HPHONE_CLEANUP = {
	private _controls = uiNameSpace getVariable "HEDES_hPhone_ActiveControls";
	{
		ctrlDelete _x;
	} foreach _controls;
	call HEDES_HPHONE_HOMESCREEN;
};


HEDES_HPHONE_APP_CLOSEAPP = {
	private _hPhone = uiNameSpace getVariable "HEDES_hPhone";
	private _hPhoneControls = uiNameSpace getVariable "HEDES_hPhone_ActiveControls";

	private _button = _hPhone ctrlCreate ["RscButton", -1];
	_button ctrlSetPosition [HEDES_HPHONE_CLOSEBUTTONX * safeZoneW + safeZoneX,HEDES_HPHONE_CLOSEBUTTONY * safeZoneH + safeZoneY, HEDES_HPHONE_CLOSEBUTTONW * safeZoneW, HEDES_HPHONE_CLOSEBUTTONH * safeZoneH];
	_button buttonSetAction "
		call HEDES_HPHONE_CLEANUP;
	";
	_button ctrlSetTooltip "Home";
	_button ctrlCommit 0;
	_hPhoneControls append [_button];
};


HEDES_HPHONE_RENDERPHONE = {
	private _hPhone = uiNameSpace getVariable "HEDES_hPhone"; 
	private _hPhoneControls = uiNameSpace getVariable "HEDES_hPhone_ActiveControls";
	private _img = _hPhone ctrlCreate ["RscPicture",-1];

	_img ctrlSetText "\x\HEDES\addons\hphone\hphone_rugged_1024.paa";
	_img ctrlSetPosition [0 * safeZoneW + safeZoneX,.25 * safeZoneH + safeZoneY,.5 * safeZoneW,.75 * safeZoneH];
	_img ctrlCommit 0;

	_hPhoneControls append [_img];
};


HEDES_HPHONE_APP_OPENMAP = {
	private _hPhone = uiNameSpace getVariable "HEDES_hPhone";
	private _hPhoneControls = uiNameSpace getVariable "HEDES_hPhone_ActiveControls";

	call HEDES_HPHONE_RENDERPHONE;
	call HEDES_HPHONE_APP_CLOSEAPP;

	_map = _hPhone ctrlCreate ["RscMapControl", -1];
	_map ctrlMapSetPosition  [
		HEDES_HPHONE_APPX * safeZoneW + safeZoneX,
		HEDES_HPHONE_APPY * safeZoneH + safeZoneY, 
		HEDES_HPHONE_APPW * safeZoneW, 
		HEDES_HPHONE_APPH * safeZoneH];
    _map ctrlMapAnimAdd [.2, 1, player];
	ctrlMapAnimCommit _map;
	ctrlSetFocus _map;
	_map ctrlCommit 0;

	_hPhoneControls append [_map];
};


HEDES_HPHONE_APP_DIAG = {
	private _hPhone = uiNameSpace getVariable "HEDES_hPhone";
	private _hPhoneControls = uiNameSpace getVariable "HEDES_hPhone_ActiveControls";

	call HEDES_HPHONE_RENDERPHONE;
	call HEDES_HPHONE_APP_CLOSEAPP;

	private _text = _hPhone ctrlCreate ["RscStructuredText", -1];
	_text ctrlSetPosition  [
		HEDES_HPHONE_APPX * safeZoneW + safeZoneX,
		HEDES_HPHONE_APPY * safeZoneH + safeZoneY, 
		HEDES_HPHONE_APPW * safeZoneW, 
		HEDES_HPHONE_APPH * safeZoneH];
	_text ctrlSetFont "TahomaB";
	_text ctrlSetFontHeight .02;
	_text ctrlCommit 0;
	ctrlSetFocus _text;

	_text spawn {
		private _message = "Diagnostics Information:<br/>- Number of Players: %1<br/>- Active Units %2<br/>- 
Units To Clean: %3<br/><br/>Simulation Stats:<br/>- Units with Simulation Enabled: %4<br/>- Units with 
Simulation Disabled: %5<br/><br/>Active Units In Cleanup Array: %6<br/>Active Groups In Cleanup Array: %7";
		while{(ctrlParent _this) isNotEqualTo displayNull} do
		{
			_this ctrlSetStructuredText parseText format[
				_message,
				count allPlayers, 
				count (allUnits select {!(_x in allPlayers)}),
				count (HEDES_GLOBALCLEANUPLIST),
				count (allUnits select {simulationEnabled _x}),
				count (allUnits select {!(simulationEnabled _x)}),
				count (allUnits select {_x in (HEDES_GLOBALCLEANUPLIST apply {_x #0})}),
				count (allgroups select {_x in (HEDES_GLOBALCLEANUPLIST apply {_x #0})})];
			sleep 5;
		}
	};

	_hPhoneControls append [_text];
};


HEDES_HPHONE_APPS = [
	["HEDES_HPHONE_APP_DIAG", "Diagnostics", "\a3\Data_f\Flags\flag_Altis_co.paa"],
	["HEDES_HPHONE_APP_OPENMAP", "hPhone Maps", "\a3\Data_f\Flags\flag_Altis_co.paa"]];
HEDES_HPHONE_HOMESCREEN = {
	private _hPhone = uiNameSpace getVariable "HEDES_hPhone";
	private _hPhoneControls = uiNameSpace getVariable "HEDES_hPhone_ActiveControls";

	call HEDES_HPHONE_RENDERPHONE;
	call HEDES_HPHONE_APP_CLOSEAPP;

	private _hPhone = uiNameSpace getVariable "HEDES_hPhone"; 
	private _i = 0;
	private _xpos = -.25;
	private _xstart = .18;
	private _xincrement = .0475;
	private _ypos = .35;	
	private _yincrement = .08;
	private _width = .035;
	private _height = .058;

	{
		_xpos = _xpos + _xincrement;
		if ((_i%3)==0) then
		{
			_ypos = _ypos + _yincrement;
			_xpos = _xstart;
		};

		private _button = _hPhone ctrlCreate ["RscButtonMenu", -1];
		_button ctrlSetStructuredText composeText [image (_x # 2)];
		_button ctrlSetFontHeight .046;
		_button ctrlSetTooltip (_x # 1);
		_button ctrlSetPosition [_xpos * safeZoneW + safeZoneX,_ypos * safeZoneH + safeZoneY, _width * safeZoneW, _height * safeZoneH];
		_button buttonSetAction format["
			call %1;
		",_x # 0];
		_button ctrlCommit 0;

		_hPhoneControls append [_button];

		_i = _i + 1;
	} forEach HEDES_HPHONE_APPS;	
};

call HEDES_HPHONE_HOMESCREEN;
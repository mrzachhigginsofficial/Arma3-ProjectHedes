class CfgRemoteExec
{
	class Commands
	{
		mode = 1;

		ALLOWREMOTE_FUNCWPRE(addaction,2,0)
		ALLOWREMOTE_FUNCWPRE(removeaction,2,0)
	};

	class Functions
	{
		mode = 1;
		jip = 0;

		ALLOWREMOTE_FUNCWPRE(BIS_fnc_effectKilledAirDestruction,0,0)
		ALLOWREMOTE_FUNCWPRE(BIS_fnc_effectKilledSecondaries,0,0)
		ALLOWREMOTE_FUNCWPRE(BIS_fnc_objectVar,0,0)
		ALLOWREMOTE_FUNCWPRE(BIS_fnc_setCustomSoundController,0,0)

		ALLOWREMOTE_FUNC(DefaultGroupMissionManager,2,0)
	};
};
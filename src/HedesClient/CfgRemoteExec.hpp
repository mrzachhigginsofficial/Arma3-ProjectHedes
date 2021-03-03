class CfgRemoteExec
{
	class Commands
	{
		mode = 1;

		class setFuel	 											{ allowedTargets = 2; };		// execute only on server
		class hint		 											{ jip = 0; };					// jip is not allowed for this command
	};

	class Functions
	{
		mode = 1;

		class BIS_fnc_setRank 										{ allowedTargets = 0; };
		class BIS_fnc_effectKilledAirDestruction					{ allowedTargets = 0; jip = 0; };
		class BIS_fnc_effectKilledSecondaries						{ allowedTargets = 0; jip = 0; };
		class BIS_fnc_objectVar										{ allowedTargets = 0; jip = 0; };
		class BIS_fnc_setCustomSoundController						{ allowedTargets = 0; jip = 0; };
		class HEDESClient_fnc_cameradeploystart						{ allowedTargets = 1; };
		class HEDESClient_fnc_cameramissionstart					{ allowedTargets = 1; };
		class HEDESClient_fnc_3p_alambientbattle_tracer_effect		{ jip = 1 };
		class HEDESClient_fnc_3p_alambientbattle_flaks_effect		{ jip = 1 };
		class HEDESClient_fnc_3p_alambientbattle_missiles_effect	{ jip = 1 };
		class HEDESClient_fnc_3p_alambientbattle_artillery_effect	{ jip = 1 };
		class HEDESClient_fnc_3p_alambientbattle_searchlight_effect	{ jip = 1 };
	};
};
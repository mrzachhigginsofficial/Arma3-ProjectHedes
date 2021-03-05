class CfgRemoteExec
{
	class Commands
	{
		mode = 1;

		class setFuel { 
			allowedTargets = 2; 
		};

		class hint 
		{ 
			jip = 0; 
		};
	};

	class Functions
	{
		mode = 2;
		jip = 0;

		class BIS_fnc_effectKilledAirDestruction	{ allowedTargets = 0; jip = 0; };
		class BIS_fnc_effectKilledSecondaries		{ allowedTargets = 0; jip = 0; };
		class BIS_fnc_objectVar						{ allowedTargets = 0; jip = 0; };
		class BIS_fnc_setCustomSoundController		{ allowedTargets = 0; jip = 0; };
	};
};
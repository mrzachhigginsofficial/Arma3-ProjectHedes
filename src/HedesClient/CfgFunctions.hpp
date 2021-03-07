class CfgFunctions 
{
	class MODNAME
	{
		class init
		{
			PATHTO_INITFUNC(initclient)
		};

		class ALambientbattle
		{
			PATHTO_FUNCDIR(alambientbattle_tracer_effect,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_flaks_effect,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_missiles_effect,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_artillery_effect,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_searchlight_effect,ALambientbattle)
		};
	};
};
class CfgFunctions 
{
	class HEDESClient
	{
		class init
		{
			file = "x\HedesClient\functions\init";
			class initmod {	
				postinit = 1;
				recompile = 1;
			};
		};

		class camera
		{
			file = "x\HedesClient\functions\camera";
			class cameradeploystart 					{recompile = 1;};
			class cameramissionstart 					{recompile = 1;};
		};

		class ALambientbattle
		{
			file = "x\HedesClient\functions\ALambientbattle";
			class alambientbattle_tracer_effect 		{recompile = 1;};
			class alambientbattle_flaks_effect 			{recompile = 1;};
			class alambientbattle_missiles_effect 		{recompile = 1;};
			class alambientbattle_artillery_effect 		{recompile = 1;};
			class alambientbattle_searchlight_effect 	{recompile = 1;};
		};
	};
};
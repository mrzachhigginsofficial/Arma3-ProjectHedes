class CfgFunctions 
{
	class HEDESServer
	{
		class init
		{
			file = "x\HedesServer\functions\init";

			class initmod {	
				postinit = 1;
				recompile = 1;
			};

			class defaultmissionsystem
			{
				postinit = 0;
				recompile = 1;
			};
		};

		class ALambientbattle
		{
			file = "x\HedesServer\functions\ALambientbattle";

			class alambientbattle_tracer 				{recompile = 1;};
			class alambientbattle_flaks 				{recompile = 1;};
			class alambientbattle_missiles 				{recompile = 1;};
			class alambientbattle_artillery 			{recompile = 1;};
			class alambientbattle_searchlight 			{recompile = 1;};
		};
	};
};


class CfgHedesMissions
{
	class default {
		/* 
			Default Mission Class - To be used as a template
			Description: Mission manager functions have the following pattern...
				1. Lookup args class names (array)
				2. Get arg property values (array - args)
				3. Lookup function name (fnc)
				4. call compile format ["%1 call %2",args,fnc]
		*/
		missioncmndr				= "Major Meathead";
		deploycamfnc				= "HEDESClient_fnc_cameradeploystart";
		deploycamargs[]				= {
			"deploycamsound",
			"deploycamcaption",
			"deploycamtransition",
			"deployduration"};
		deploycamcaption			= "Deploying...";
		deploycamsound				= "OMComputerSystemStart";
		deploycamtransition			= "BLACK OUT";
		deployduration				= 2;
		missionstartcamfnc 			= "HEDESClient_fnc_cameramissionstart";
		missionstartcamargs[]		= {
			"missioncmndr",
			"missionstarttext",
			"missionstartaudio"
		};
		missionstarttext			= "Mission is a go, I repeat, mission is a go. Command out.";
		missionstartaudio			= "RadioAmbient5";
		missionsquadmultiplier		= 1.2;	// Difficult Multiplier. NPC presence and/or difficult increases when more players join.
		ambientartillery 			= 1; 	// Should random artillery be landing around AO - 1 true, 0 false
		ambientartilleryfnc			= ""; 	// Function that controls ambient artillery
		ambientbattleeffects		= 1; 	// Should ambient battle effects be running around AO - 1 true, 0 false
		ambientbattleeffectsfnc		= ""; 	// Function that controls the ambient battle effects (client side function)
		ambientcivillians			= 0; 	// Should there be a civilian presence around the AO - 1 true, 0 false
		missionmanagerfnc			= "HEDESServer_fnc_DefaultGroupMissionManager"; 	// Function that bootstraps the mission and manages all mission objects for team
		missiondeployobjtype		= "B_Boat_Transport_01_F";
		missiondingressambientparam = "sea - waterDepth + (waterDepth factor [0.05, 0.5])"; //https://community.bistudio.com/wiki/Ambient_Parameters
		missiontargetarea 			= "camp remnants";
		missiontargetareatype		= "nameLocal";
		missiongtargetareaargs[]	= {
			"missiontargetarea",
			"missiontargetareatype"
		};
		missionhq					= "Ile Sainte-Marie";
		missionhqtype 				= "nameLocal";
		missionhqargs[]				= {
			"missionhq",
			"missionhqtype"
		};
	};

	class patrol : default {

	};

	class destroy : default {

	};

	class defend : default {

	};

	class assassinate : default {

	};

	class rescue : default {

	};
};
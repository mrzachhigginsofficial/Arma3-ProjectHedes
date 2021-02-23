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

		class missions 
		{
			file = "x\HedesServer\functions\mission\default";

			class GetMissionArgProperties 				{recompile = 1;};
			class CompilePlayerTransitionCamera			{recompile = 1;};
			class DefaultGroupMissionManager			{recompile = 1;};
			class GetLocationPosByName					{recompile = 1;};
			class SetPlayerMissionState					{recompile = 1;};
			class GetPlayerMissionState					{recompile = 1;};
			class CheckKillTask							{recompile = 1;};
			class CreateKillTask						{recompile = 1;};
			class SpawnEnemySquad						{recompile = 1;};
			class SetGroupSurrenderEffect				{recompile = 1;};
		}
	};
};


class CfgHedesMissions
{
	class default {
		/* 
			Default Mission Class - To be used as a template and demo.
			Description: Mission manager functions have the following pattern...
				1. Lookup args class names (array)
				2. Get arg property values (array - args)
				3. Lookup function name (fnc)
				4. call compile format ["%1 call %2",args,fnc]
			When creating a mission, it is highly recommend that the default class be inherited, 
				and customizations applied as the mission parameters change.
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
		returncamfnc				= "HEDESClient_fnc_cameramissionstart";
		returncamargs[]				= {
			"missioncmndr",
			"returncamtext",
			"returncamaudio"
		};
		returncamtext				= "";
		returncamaudio				= "";
		finishedcamfnc				= "HEDESClient_fnc_cameradeploystart";
		finishedcamargs[]			= {
			"deploycamsound",
			"finishedcamcaption",
			"deploycamtransition",
			"deployduration"
		};
		finishedcamcaption			= "";
		missionstartcamfnc 			= "HEDESClient_fnc_cameramissionstart";
		missionstartcamargs[]		= {
			"missioncmndr",
			"missionstarttext",
			"missionstartaudio"
		};
		missionstarttext			= "Mission is a go, I repeat, mission is a go. Command out.";
		missionstartaudio			= "RadioAmbient5";
		missiondifficultymultiplier	= 1.2;	// Difficult Multiplier. NPC presence and/or difficult increases when more players join.
		ambientartillery 			= 1; 	// Should random artillery be landing around AO - 1 true, 0 false
		ambientartilleryfnc			= ""; 	// Function that controls ambient artillery
		ambientbattleeffects		= 1; 	// Should ambient battle effects be running around AO - 1 true, 0 false
		ambientbattleeffectsfnc		= ""; 	// Function that controls the ambient battle effects (client side function)
		ambientcivillians			= 0; 	// Should there be a civilian presence around the AO - 1 true, 0 false
		missionmanagerfnc			= "HEDESServer_fnc_DefaultGroupMissionManager"; 	// Function that bootstraps the mission and manages all mission objects for team
		missiondeployobjtype		= "B_Boat_Transport_01_F";
		missionextractobjtype		= "B_Boat_Transport_01_F";
		missiondingressambientexpre = "sea - waterDepth + (waterDepth factor [0.05, 0.5])"; // Helps find a suitable location to start players - https://community.bistudio.com/wiki/Ambient_Parameters
		missiontargetarea 			= "camp remnants";	// Name of location as it appears on the map
		missiontargetareatype		= "nameLocal";		// Location type - refer to https://community.bistudio.com/wiki/Location
		missiontargetareaargs[]	= {
			"missiontargetarea",
			"missiontargetareatype"
		};
		missionhq					= "Ile Sainte-Marie";
		missionhqtype 				= "nameLocal";
		missionhqargs[]				= {
			"missionhq",
			"missionhqtype"
		};
		missionenemyambientparam	= ""; //not used yet
		missionmaxenemysquads		= 3;
		missionunitspersquad		= 5;
		missionenemyunitpool[]		= {
			"O_G_Soldier_F",
			"O_G_Soldier_lite_F",
			"O_G_Soldier_SL_F",
			"O_G_Soldier_TL_F",
			"O_G_Soldier_AR_F",
			"O_G_medic_F",
			"O_G_engineer_F",
			"O_G_Soldier_exp_F",
			"O_G_Soldier_GL_F",
			"O_G_Soldier_M_F",
			"O_G_Soldier_LAT_F",
			"O_G_Soldier_A_F",
		};
		missionenemyunitvippool[]	= {
			"O_G_officer_F"
		};
		missionenemyunitspawnfnc	= "HEDESServer_fnc_SpawnEnemySquad"; // params - [group,enemytypearray,spawnpos,number of enemies]
		playermissiontrackerglobal	= "HEDESServer_Profile_PlayerMissionTracker"; //  structure - [group,state,mission,objs]
		playermissionstatesetterfnc = "HEDESServer_fnc_SetPlayerMissionState";
		playermissionstategetterfnc = "HEDESServer_fnc_GetPlayerMissionState";
		tasks[]						= {
			/*
			Task generation systems works in 3 phases	
				1. taskgeneration - Creates the task
				2. object creation - Creates the focus object of the task
				3. check task - Evaluates the focus object from #2 and emits true when satisfied
			Example: {"taskgeneration","objectspawner","taskevaluation"}
				Taskgeneration function should output [position, taskname]
					1. Outputs array [position, taskname]
				Objectspawner creates the object or group that is to be evaluated. The output is passed to taskevaluation.
					1. Accepts all mission params defined in taskspawnargs + position of task
					2. Example [configParam1,configParam2,_position]
				Taskevaluation function will paused until task complete 
					1. Takes all output from Objectspawner as parameters
				The example below creates a task chain of 2 tasks for this mission
			*/
			{
				"HEDESServer_fnc_CreateKillTask",		// 1. Creates a kill task - input: _groupnetid(owner) - output: [_missionpos, _missionTask]
				"HEDESServer_fnc_SpawnEnemySquad",		// 2. Creates mission object - input: _taskspawnargs[] pushBack _position - ouput: enemy squad netid
				"HEDESServer_fnc_CheckKillTask"			// 3. Waits Until Objective Complete - input: output of objectspawner - output: true
				},
			{
				"HEDESServer_fnc_CreateKillTask",
				"HEDESServer_fnc_SpawnEnemySquad",
				"HEDESServer_fnc_CheckKillTask"
				}
		};
		taskspawnargs[]				= {
			"missionenemyunitpool",
			"missionunitspersquad"
		};
		taskeffectsfnc[]=
		{
			// [task object] call <function> syntax
			"HEDESServer_fnc_SetGroupSurrenderEffect"
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
class CfgHedesMissions
{
	playermissiontrackerglobal		= "HEDESServer_Profile_PlayerMissionTracker"; //  structure - [group,state,mission,objs,tasks]
	playermissionstatesetterfnc 	= "HEDESServer_fnc_SetPlayerMissionState";
	playermissionstategetterfnc 	= "HEDESServer_fnc_GetPlayerMissionState";
	playermissionnamegetterfnc 		= "HEDESServer_fnc_GetPlayerMissionName";
	playermissionobjectsgetfnc		= "HEDESServer_fnc_GetPlayerMissionObjects";
	appendplayermissionobjectfnc 	= "HEDESServer_fnc_AppendPlayerMissionObject";
	cleanupmissionplayerobjectfnc	= "HEDESServer_fnc_SpawnObjectCleanupThread";

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
		missionmanagerfnc			= "HEDESServer_fnc_DefaultGroupMissionManager"; 	// Function that bootstraps the mission and manages all mission objects for team
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
		taskspawnargs[]				= {
			"missionenemyunitpool",
			"missionunitspersquad"
		};
		taskeffectsfnc[]			= {
			// [task object] call <function> syntax
			"HEDESServer_fnc_SetGroupSurrenderEffect",
			"HEDESServer_fnc_SetObjectExplosion"
		};

		class tasks 
		{
			class kill
			{
				createtaskfnc = "HEDESServer_fnc_CreateTask";
				createareafnc = "HEDESServer_fnc_SpawnObjectiveArea";
				checktaskfnc = "HEDESServer_fnc_CheckTask";
			};
			class destroy
			{
				createtaskfnc = "HEDESServer_fnc_CreateTask";
				createareafnc = "HEDESServer_fnc_SpawnObjectiveArea";
				checktaskfnc = "HEDESServer_fnc_CheckTask";
			};
		};
	};
};
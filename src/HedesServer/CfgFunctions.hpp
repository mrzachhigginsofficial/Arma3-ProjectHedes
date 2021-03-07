class CfgFunctions 
{
	class MODNAME
	{
		class init
		{
			PATHTO_INITFUNC(initserver)
		};

		class ALambientbattle
		{
			PATHTO_FUNCDIR(alambientbattle_tracer,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_flaks,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_missiles,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_artillery,ALambientbattle)
			PATHTO_FUNCDIR(alambientbattle_searchlight,ALambientbattle)
		};

		class maintenance
		{
			PATHTO_FUNCDIR(AddUnitToCleanupList,maintenance)
			PATHTO_FUNCDIR(SpawnUnitCleanupThread,maintenance)
		};

		class persistence
		{
			PATHTO_FUNCDIR(SaveLoudOut,persistence)
			PATHTO_FUNCDIR(LoadLoudout,persistence)
		};

		class missions 
		{
			PATHTO_FUNCDIR(AppendPlayerMissionObject,mission\default)
			PATHTO_FUNCDIR(CheckTask,mission\default)
			PATHTO_FUNCDIR(CheckAssassinateTask,mission\default)
			PATHTO_FUNCDIR(CompilePlayerTransitionCamera,mission\default)
			PATHTO_FUNCDIR(CreateDestroyTask,mission\default)
			PATHTO_FUNCDIR(CreateAssassinateTask,mission\default)
			PATHTO_FUNCDIR(CreateMeetTask,mission\default)
			PATHTO_FUNCDIR(CreateMissionTask,mission\default)
			PATHTO_FUNCDIR(DefaultGroupMissionManager,mission\default)
			PATHTO_FUNCDIR(GetMissionArgProperties,mission\default)
			PATHTO_FUNCDIR(GetLocationPosByName,mission\default)
			PATHTO_FUNCDIR(GetPlayerMissionState,mission\default)
			PATHTO_FUNCDIR(GetPlayerMissionName,mission\default)
			PATHTO_FUNCDIR(GetPlayerMissionObjects,mission\default)
			PATHTO_FUNCDIR(SpawnEnemySquad,mission\default)
			PATHTO_FUNCDIR(SetPlayerTaskList,mission\default)
			PATHTO_FUNCDIR(SetPlayerMissionState,mission\default)
			PATHTO_FUNCDIR(SpawnEnemyObject,mission\default)
			PATHTO_FUNCDIR(SpawnObjectiveArea,mission\default)		
			PATHTO_FUNCDIR(SpawnAssassinateObjective,mission\default)
		};
	};
};
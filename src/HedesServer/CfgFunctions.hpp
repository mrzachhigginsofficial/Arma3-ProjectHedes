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

		class session 
		{
			file = "x\HedesServer\functions\session";

			class MovePlayerInMission					{recompile = 1;};
			class RespawnPlayer 						{recompile = 1;};
			class SetupNewPlayer 						{recompile = 1;};
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
			class CheckTask								{recompile = 1;};
			class CreateTask							{recompile = 1;};
			class SpawnEnemySquad						{recompile = 1;};
			class SetGroupSurrenderEffect				{recompile = 1;};
			class AppendPlayerMissionObject				{recompile = 1;};
			class SetPlayerTaskList						{recompile = 1;};
			class GetPlayerMissionName 					{recompile = 1;};
			class SpawnEnemyObject						{recompile = 1;};
			class SpawnObjectiveArea					{recompile = 1;};
			class GetPlayerMissionObjects				{recompile = 1;};
			class SpawnObjectCleanupThread				{recompile = 1;};
			class SetObjectExplosion					{recompile = 1;};
		}
	};
};
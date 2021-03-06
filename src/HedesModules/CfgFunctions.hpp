class CfgFunctions 
{
	class MODNAME
	{
		class ModuleFunctions
		{
			//-- Mission System Inits & GUI
			PATHTO_FUNC(InitMissionSystemModule)
			PATHTO_FUNC(ShowAvailableMissions)

			//-- Mission System Task Effects
			PATHTO_FUNC(SetObjectExplosionEffect)
			PATHTO_FUNC(SetGroupSurrenderEffect)

			//-- Area Patrols (Ambient Units)
			PATHTO_FUNC(InitAreaPatrollingVehicles)
		};
	};
};
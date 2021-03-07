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

			//-- Ambient Unit Inits
			PATHTO_FUNC(InitAreaPatrollingVehicles)
			PATHTO_FUNC(InitAreaAmbientCivs)
		};
	};
};
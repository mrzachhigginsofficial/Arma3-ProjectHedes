#include "macros.h"
#include "defines.h"

class CfgPatches
{
	class ProjectHedesModules
	{
        name = "Project Hedes Modules";
		author = "ZanchoElGrande";
		url = "";
		requiredVersion = 0.1;
		fileName = "HEDESModulesMod.pbo";
        units[] = {
			"HEDES_MissionModule_BASE",
			"HEDES_MissionModule_HQ",
			"HEDES_MissionModule_DEPLOY",
			"HEDES_MissionModule_INGRESS",
			"HEDES_MissionModule_SYSTEM",
			"HEDES_MissionModule_TASK",
			"HEDES_MissionModule_TASKEFFECT",
			"HEDES_MissionModule_MANAGER",
			"HEDES_GenericModule_UNITPOOL"
			};
		weapons[] = {};
        requiredAddons[] = {
			"ProjectHedesCommon",
			"ProjectHedesServer"
		};
	};
};

#include "CfgFactionClasses.hpp"
#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"

#include "gui\BaseControlClasses.hpp"
#include "gui\MissionGiverDialog.hpp"
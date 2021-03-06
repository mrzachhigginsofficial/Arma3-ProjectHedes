#include "macros.h"

class CfgPatches
{
	class ProjectHedesClient
	{
        name = "Project Hedes Client";
		author = "ZanchoElGrande";
		url = "";
		requiredVersion = 0.1;
		fileName = "HEDESClientMod.pbo";
        units[] = {};
		weapons[] = {};
        requiredAddons[] = {
			"ProjectHedesCommon",
			"ProjectHedesModules"
		};
	};
};

#include "CfgFunctions.hpp"
#include "macros.h"

class CfgPatches
{
	class ProjectHedesServer
	{
        name = "Project Hedes Server";
		author = "ZanchoElGrande";
		url = "";
		requiredVersion = 0.1;
		fileName = "HEDESServerMod.pbo";
        units[] = {
			"UnterKomando_1",
			
		};
		weapons[] = {};
        requiredAddons[] = {};
	};
};

#include "CfgRemoteExec.hpp"
#include "CfgFunctions.hpp"
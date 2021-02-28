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

class CfgRemoteExec
{
	class Commands
	{
		mode = 1;
	};

	class Functions
	{
		mode = 0;
		jip = 0;
	};
};

#include "CfgFunctions.hpp"
#include "CfgHedesMissions.hpp"
#include "CfgHedesSessionManagers.hpp"
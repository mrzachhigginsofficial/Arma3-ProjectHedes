class CfgPatches
{
	class ProjectHedesServer
	{
        name = "Project Hedes Server";
		author = "ZanchoElGrande";
		url = "";
		requiredVersion = 0.1;
		fileName = "HEDESServerMod.pbo";
        units[] = {};
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

#include "config.hpp"
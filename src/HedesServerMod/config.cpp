class CfgPatches
{
	class ProjectHedesServer
	{
        name = "Project Hedes Server";
		author = "ZanchoElGrande";
		url = "";
		requiredVersion = 0.1;
		fileName = "HEDES_Server.pbo";
        units[] = {};
		weapons[] = {};
        requiredAddons[] = { };
	};
};

class CfgFunctions 
{
	#include "config.hpp"
};

class CfgRemoteExec
{
	class Commands
	{
		mode = 1;

		class setFuel			{ allowedTargets = 2; };
		class hint				{ jip = 0; };
		class hintsilent		{ jip = 0; };
	};

	class Functions
	{
		mode = 0;
		jip = 0;

		class BIS_fnc_setRank 	{ allowedTargets = 1; };
	};
};
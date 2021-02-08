class CfgPatches
{
	class ProjectHedesClient
	{
        name = "Project Hedes Client";
		author = "ZanchoElGrande";
		url = "";
		requiredVersion = 0.1;
		fileName = "HEDES_Client.pbo";
        units[] = {};
		weapons[] = {};
        requiredAddons[] = { };
	};
};

class CfgFunctions 
{
    //#include "initializations\init_config.hpp"
    //#include "globalvariables\globals_config.hpp"
    //#include "functionslibrary\fl_config.hpp"
};

class CfgRemoteExec
{
	class Commands
	{
		mode = 1;

		class setFuel	{ allowedTargets = 2; };		// execute only on server
		class hint		{ jip = 0; };					// jip is not allowed for this command
	};

	class Functions
	{
		mode = 0;
		jip = 0;										// no functions can use jip

		class BIS_fnc_setRank { allowedTargets = 1; };	// execute only on clients, server execution denied
	};
};
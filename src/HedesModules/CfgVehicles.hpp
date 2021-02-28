class CfgVehicles
{
	class Logic;

	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;
			class Combo;
			class Checkbox;
			class CheckboxNumber;
			class ModuleDescription;
			class Units;
		};
		class ModuleDescription
		{
			class AnyBrain;
		};
	};

	class HEDES_MissionModule_BASE : Module_F
	{
		category 			= "HEDES_MissionModules";
		displayName 		= "Mission Manager Base Module (Empty)";
		functionPriority	= 1;
		is3DEN 				= 0;
		isGlobal 			= 2;
		isTriggerActivated 	= 0;
		scope 				= 2;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = "HEDES_MissionModule_Units";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE"};
		};
	};

	class HEDES_MissionModule_HQ : HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Manager HQ";

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE"};
		};
	};

	class HEDES_MissionModule_DEPLOY : HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Deploy Area";

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE"};
		};
	};

	class HEDES_MissionModule_INGRESS : HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Ingress";

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE"};
		};
	};

	class HEDES_MissionModule_SYSTEM: HEDES_MissionModule_BASE
	{
		displayName 		= "Mission System Module";
		function			= "HEDESModules_fnc_InitMissionSystemModule";

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE","AnyBrain"};
		};
	};

	class HEDES_MissionModule_TASK: HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Task Module";
		function			= "HEDESModules_fnc_InitMissionSystemModule";

		class Attributes: AttributesBase
		{
			class TaskType : Combo
			{
				property 			= "HEDES_MissionModule_TaskType";
				displayName 		= "Task Type";
				tooltip 			= "The task the mission will spawn.";
				defaultValue 		= "'destory'";
				
				class Values
				{
					class default	{
						name 			= "Destory Mission"; 
						value 			= "destroy";
					};
				};
			};

			class TaskName : Edit
			{
				property 			= "HEDES_MissionModule_TaskName";
				displayName 		= "Mission Manager Name";
				tooltip 			= "Mission manager name. This doesn't really serve a purpose yet.";
				defaultValue 		= """Task Name""";
			};

			class TaskDescription : Edit
			{
				property 			= "HEDES_MissionModule_TaskDesc";
				displayName 		= "Mission Manager Name";
				tooltip 			= "Mission manager name. This doesn't really serve a purpose yet.";
				defaultValue 		= """Task Description""";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE","AnyBrain"};
		};
	};

	class HEDES_MissionModule_MANAGER: HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Manager Module";

		class Attributes: AttributesBase
		{
			class MissionType : Combo
			{
				property 			= "HEDES_MissionModule_Type";
				displayName 		= "Mission Type";
				tooltip 			= "The type of mission manager used.";
				defaultValue 		= "'default'";
				
				class Values
				{
					class default	{
						name 			= "Default Mission Manager"; 
						value 			= "default";
					};
				};
			};

			class MissionManagerName : Edit
			{
				property 			= "HEDES_MissionModule_Name";
				displayName 		= "Mission Manager Name";
				tooltip 			= "Mission manager name. This doesn't really serve a purpose yet.";
				defaultValue 		= """Mission Action Name""";
			};

			class MissionManagerObjectType : Edit
			{
				property 			= "HEDES_MissionModule_ObjectType";
				displayName 		= "Mission Manager Object Type";
				tooltip 			= "Only required if objective requires object.";
				defaultValue 		= """Land_CratesWooden_F""";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE"};
		};
	};
};
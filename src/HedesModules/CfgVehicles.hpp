class CfgVehicles
{
	class Logic;

	class Module_F: Logic
	{
		class AttributesBase
		{
			class Checkbox;
			class CheckboxNumber;
			class Combo;
			class Default;
			class Edit;
			class ModuleDescription;
			class StructuredText;
			class Units;
		};

		class ModuleDescription;
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
				property 		= "HEDES_MissionModule_Units";
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
	};

	class HEDES_MissionModule_DEPLOY : HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Deploy Area";
	};

	class HEDES_MissionModule_INGRESS : HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Ingress";
	};

	class HEDES_MissionModule_SYSTEM: HEDES_MissionModule_BASE
	{
		displayName 		= "Mission System Module";
		function			= "HEDESModules_fnc_InitMissionSystemModule";

		class Attributes: AttributesBase
		{
			class MissionGiverName : Edit
			{
				property 			= "HEDES_MissionSystem_GiverName";
				displayName 		= "Mission Giver Name";
				tooltip 			= "The name of the mission giver.";
				defaultValue 		= """Ivan Wojszyk""";
			};

			class MissionGiverAvatar : Edit
			{
				property 			= "HEDES_MissionSystem_GiverAvatar";
				displayName 		= "Mission Giver Avatar";
				tooltip 			= "The avatar of the mission giver.";
				defaultValue 		= """\assets\avatar_missiongiver_generic1.paa""";
			};
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
				displayName 		= "Task Name";
				tooltip 			= "Task name...";
				defaultValue 		= """Task Name""";
			};

			class TaskDescription
			{
				property 			= "HEDES_MissionModule_TaskDesc";
				control 			= "EditMulti5";
				displayName 		= "Task Description";
				tooltip 			= "Task description...";
				defaultValue 		= """Task Description""";
			};
		};
	};

	class HEDES_MissionModule_TASKEFFECT: HEDES_MissionModule_BASE
	{
		displayName 		= "Mission Task Effect Module";

		class Attributes: AttributesBase
		{
			class EffectType : Combo
			{
				property 			= "HEDES_MissionModule_EffectType";
				displayName 		= "Task Effect Type";
				tooltip 			= "Type of task effect to add.";
				defaultValue 		= "";
				
				class Values
				{
					class explosive	{
						name 			= "Plant Explosive Action On Objects"; 
						value 			= FUNC(SetObjectExplosion);
					};

					class surrender	{
						name 			= "Enemies Can Surrender On Low Morale"; 
						value 			= FUNC(SetGroupSurrenderEffect);
					};
				};
			};
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
						name 			= "Default Mission Manager (Must Define Object)"; 
						value 			= "default";
					};
				};
			};

			class MissionManagerObjectType : Edit
			{
				property 			= "HEDES_MissionModule_ObjectType";
				displayName 		= "Mission Manager Objective Object";
				tooltip 			= "Only required if objective requires object.";
				defaultValue 		= """Land_CratesWooden_F""";
			};

			class MissionName : Edit
			{
				property 			= "HEDES_MissionModule_Name";
				displayName 		= "Mission Name";
				tooltip 			= "Mission name as it shows in the mission list dialog.";
				defaultValue 		= """Attack Mission""";
			};

			class MissionDescription
			{
				property 			= "HEDES_MissionModule_Description";
				control 			= "EditMulti5";
				displayName 		= "Mission Description (Flavor Text)";
				tooltip 			= "Flavor text that will display in the dialog.";
				defaultValue 		= """Mission Description Goes Here""";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description 		= "This is a short description of the mission manager module.";
			sync[] 				= {"HEDES_MissionModule_BASE"};
		};
	};

	class HEDES_GenericModule_UNITPOOL: HEDES_MissionModule_BASE
	{
		displayName			= "Unit Pool Module";

		class Attributes : AttributesBase
		{
			class UnitPool
			{
				property 			= "HEDES_Generic_UnitPool";
				control 			= "EditCodeMulti5";
				displayName 		= "Array of unit types.";
				tooltip 			= "Array of units. Must be formatted as code: ['var1','var2']";
				defaultValue 		= "['unittype1','unittype2']";
			};		
		};
	};
};
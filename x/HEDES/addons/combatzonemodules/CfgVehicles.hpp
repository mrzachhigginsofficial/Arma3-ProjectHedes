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

		class ModuleDescription
		{
			class AnyVehicle;
		};
	};

	class HEDES_CombatZoneModule_BASE : Module_F
	{
		category = "HEDES_CombatZoneModules";
		displayName = "Combat Zone Modules Base (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isGlobal = 2;
		isTriggerActivated 	= 0;
		scope = 1;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = "HEDES_CombatZoneModule_Units";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";
			sync[] = {"HEDES_CombatZoneModule_BASE"};

			class LocationArea_F
			{
				description="";
				duplicate=1;
				sync[]=
				{
					"TriggerArea"
				};
			};
			
			class TriggerArea
			{
				position=1;
				area=1;
				duplicate=1;
				vehicle="EmptyDetector";
			};
		};
	};

	/* HEDES CombatZone Modules */
	class HEDES_CombatZoneModules_Manager : HEDES_CombatZoneModule_BASE
	{
		displayName = "Combat Zone Manager Module";
		function = QUOTE(FUNCMAIN(InitCombatZoneManagerModule));
		scope = 2;

		class Attributes: AttributesBase
		{
			// EAST
			class EastVehicle : Edit
			{
				property = "HEDES_CombatZoneModules_EastVehicle";
				displayName = "(East) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """O_Heli_Light_02_unarmed_F""";
			};
			class EastIsHeli : Checkbox
			{
				property = "HEDES_MissionSystem_EastIsHeli";
				displayName = "Is Vehicle a Heli?";
				tooltip = "Is the vehicle type a helicopter?";
				defaultValue = "true";
			};
			class EastMaxUnits : Edit
			{
				property = "HEDES_CombatZoneModules_MaxUnitsEast";
				displayName = "Maximum Units (East)";
				tooltip = "Maximum number of units for this side.";
				defaultValue = "80";
				validate = "number";
				typeName = "NUMBER";
			};
			class EastUnitPool
			{
				property = "HEDES_CombatZoneModules_EastUnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['O_soldier_F','O_soldier_PG_F','O_soldier_UAV_F','O_medic_F','O_soldier_SL_F','O_soldier_A_F','O_soldier_LAT_F','O_soldier_AR_F']""";
				expression = "_this setVariable ['%s',_value];";
			};	
			// WEST
			class WestVehicle : Edit
			{
				property = "HEDES_CombatZoneModules_WestVehicle";
				displayName = "(West) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """I_Heli_light_03_unarmed_F""";
			};
			class WestIsHeli : Checkbox
			{
				property = "HEDES_MissionSystem_WestIsHeli";
				displayName = "Is Vehicle a Heli?";
				tooltip = "Is the vehicle type a helicopter?";
				defaultValue = "true";
			};
			class WestMaxUnits : Edit
			{
				property = "HEDES_CombatZoneModules_MaxUnitsWest";
				displayName = "Maximum Units (West)";
				tooltip = "Maximum number of units for this side.";
				defaultValue = "80";
				validate = "number";
				typeName = "NUMBER";
			};
			class WestUnitPool
			{
				property = "HEDES_CombatZoneModules_WestUnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['B_medic_F','B_soldier_TL_F','B_soldier_M_F','B_soldier_LAT_F','B_soldier_F','B_soldier_GL_F','B_soldier_A_F','B_soldier_AR_F']""";
				expression = "_this setVariable ['%s',_value];";
			};	
			//GUER
			class GUERVehicle : Edit
			{
				property = "HEDES_CombatZoneModules_GUERVehicle";
				displayName = "(GUER) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """I_Heli_light_03_F""";
			};
			class GUERIsHeli : Checkbox
			{
				property = "HEDES_MissionSystem_GUERIsHeli";
				displayName = "Is Vehicle a Heli?";
				tooltip = "Is the vehicle type a helicopter?";
				defaultValue = "true";
			}
			class GUERMaxUnits : Edit
			{
				property = "HEDES_CombatZoneModules_MaxUnitsGUER";
				displayName = "Maximum Units (GUER)";
				tooltip = "Maximum number of units for this side.";
				defaultValue = "80";
				validate = "number";
				typeName = "NUMBER";
			};
			class GUERUnitPool
			{
				property = "HEDES_CombatZoneModules_GUERUnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['I_soldier_TL_F','I_medic_F','I_soldier_AT_F','I_soldier_AR_F','I_soldier_TL_F','I_soldier_AA_F','I_soldier_A_F']""";
				expression = "_this setVariable ['%s',_value];";
			};	
		};
	};

	class HEDES_CombatZoneModules_Point : HEDES_CombatZoneModule_BASE
	{
		canSetArea=1;
		displayName = "Combat Zone Point Module";
		scope = 2;
	};

	class HEDES_CombatZoneModules_EastLZ : HEDES_CombatZoneModule_BASE
	{
		canSetArea=1;
		displayName = "East Landing Zone";
		scope = 2;
	};

	class HEDES_CombatZoneModules_WestLZ : HEDES_CombatZoneModule_BASE
	{
		canSetArea=1;
		displayName = "West Landing Zone";
		scope = 2;
	};

	class HEDES_CombatZoneModules_GuerLZ : HEDES_CombatZoneModule_BASE
	{
		canSetArea=1;
		displayName = "Independent Landing Zone";
		scope = 2;
	};

	class HEDES_CombatZoneModules_WestSpawn : HEDES_CombatZoneModule_BASE
	{
		canSetArea=1;
		displayName = "West Spawn Point Module";
		scope = 2;
	};

	class HEDES_CombatZoneModules_EastSpawn : HEDES_CombatZoneModule_BASE
	{
		canSetArea=1;
		displayName = "East Spawn Point Module";
		scope = 2;
	};

	class HEDES_CombatZoneModules_GuerSpawn : HEDES_CombatZoneModule_BASE
	{
		canSetArea=1;
		displayName = "Independent Spawn Point Module";
		scope = 2;
	};
};
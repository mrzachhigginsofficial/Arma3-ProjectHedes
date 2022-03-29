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

	class HEDES_CombatZoneModule_BASE : Module_F
	{
		category = "HEDES_CombatZoneModules";
		displayName = "Combat Zone Modules Base (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isGlobal = 2;
		isTriggerActivated 	= 0;
		scope = 2;

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
		};
	};

	/* HEDES CombatZone Modules */
	class HEDES_CombatZoneModules_Manager : HEDES_CombatZoneModule_BASE
	{
		displayName = "Combat Zone Manager Module";
		function = QUOTE(FUNCMAIN(InitCombatZoneManagerModule));

		class Attributes: AttributesBase
		{
			// EAST
			class EastVehicle : Edit
			{
				property = "HEDES_CombatZoneModules_EastVehicle";
				displayName = "(East) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """CUP_O_AN2_TK""";
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
				defaultValue = """['CUP_O_sla_Soldier_MG','CUP_O_sla_Engineer','CUP_O_sla_Soldier_AR','CUP_O_sla_Soldier_LAT','CUP_O_sla_Soldier_AMG','CUP_O_SLA_Soldier_Backpack','CUP_O_sla_Soldier_GL','CUP_O_sla_Soldier','CUP_O_RU_Officer_VDV_M_EMR']""";
				expression = "_this setVariable ['%s',_value];";
			};	
			// WEST
			class WestVehicle : Edit
			{
				property = "HEDES_CombatZoneModules_WestVehicle";
				displayName = "(West) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """CUP_O_AN2_TK""";
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
				defaultValue = """['CUP_B_CDF_Militia_SNW','CUP_B_CDF_Medic_SNW','CUP_B_CDF_Soldier_Marksman_SNW','CUP_B_CDF_Soldier_LAT_SNW','CUP_B_CDF_Soldier_MG_SNW','CUP_B_CDF_Soldier_TL_SNW']""";
				expression = "_this setVariable ['%s',_value];";
			};	
			//GUER
			class GUERVehicle : Edit
			{
				property = "HEDES_CombatZoneModules_GUERVehicle";
				displayName = "(GUER) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """CUP_O_AN2_TK""";
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
				defaultValue = """['CUP_I_PMC_Engineer','CUP_I_PMC_Crew','CUP_I_PMC_Medic','CUP_I_PMC_Soldier_TL','CUP_I_PMC_Soldier_MG_PKM','CUP_I_PMC_Soldier_GL','CUP_I_PMC_Bodyguard_M4','CUP_I_PMC_Soldier_AT','CUP_I_PMC_Contractor1']""";
				expression = "_this setVariable ['%s',_value];";
			};	
		};
	};

	class HEDES_CombatZoneModules_Point : HEDES_CombatZoneModule_BASE
	{
		displayName = "Combat Zone Point Module";
	};

	class HEDES_CombatZoneModules_WestSpawn : HEDES_CombatZoneModule_BASE
	{
		displayName = "West Spawn Point Module";
	};

	class HEDES_CombatZoneModules_EastSpawn : HEDES_CombatZoneModule_BASE
	{
		displayName = "East Spawn Point Module";
	};

	class HEDES_CombatZoneModules_GuerSpawn : HEDES_CombatZoneModule_BASE
	{
		displayName = "Guer Spawn Point Module";
	};
};
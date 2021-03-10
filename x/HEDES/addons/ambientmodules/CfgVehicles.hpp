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

	class HEDES_AmbientModule_BASE : Module_F
	{
		category = "HEDES_AmbientModules";
		displayName = "Ambient Modules Base (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isGlobal = 2;
		isTriggerActivated 	= 0;
		scope = 2;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = "HEDES_AmbientModule_Units";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";
			sync[] = {"HEDES_MissionModule_BASE","HEDES_AmbientModule_BASE"};
		};
	};

	/* HEDES Ambient Modules */
	class HEDES_AmbientModule_AreaVehPatrol: HEDES_AmbientModule_BASE
	{
		displayName = "Area Vehicle Patrol (Roads)";
		function = QUOTE(FUNCMAIN(InitAreaPatrollingVehicles));

		class Attributes: AttributesBase
		{
			class NumberOfVehicles : Edit
			{
				property = "HEDES_AmbientModule_NumOfVehs";
				displayName = "Number of vehicles";
				tooltip = "Number of vehicles that can be in the area at one time.";
				defaultValue = """5""";
			};

			class VehicleSpeed : Edit
			{
				property = "HEDES_AmbientModule_VehSpeed";
				displayName = "Vehicle Speed";
				tooltip = "Speed of Vehicle (50 and below is a nice choice)";
				defaultValue = """25""";
			};

			class MarkerName : Edit
			{
				property = "HEDES_AmbientModule_MarkerName";
				displayName = "Marker Name";
				tooltip = "Name of marker that the units will patrol inside of.";
				defaultValue = """Marker Name""";
			};

			class UnitPool
			{
				property = "HEDES_AmbientModule_UnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['CUP_O_LR_MG_TKM','CUP_O_LR_SPG9_TKM']""";
				expression = "_this setVariable ['%s',_value];";
			};	
		};
	};

	class HEDES_AmbientModule_Civilians: HEDES_AmbientModule_BASE
	{
		displayName = "Area Ambient Civs";
		function = QUOTE(FUNCMAIN(InitAreaAmbientCivs));

		class Attributes: AttributesBase
		{
			class NumbersofCivs : Edit
			{
				property = "HEDES_AmbientModule_NumOfCivs";
				displayName = "Number of Civilians";
				tooltip = "Number of civilians that can be in the area at one time.";
				defaultValue = """5""";
			};

			class UnitPool
			{
				property = "HEDES_AmbientModule_UnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types that will spawn as civilians.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only infantry allowed.";
				defaultValue = """['CUP_C_R_Rocker_01','CUP_C_TK_Man_05_Jack','CUP_C_TK_Man_05_Waist','CUP_C_TK_Man_06_Waist']""";
				expression = "_this setVariable ['%s',_value];";
			};	
			
			class SuicideBombers : Checkbox
			{
				property = "HEDES_AmbientModule_Suicide";
				displayName = "Suicide Bombers?";
				tooltip = "Should the civilians have the change to spawn as suicide bombers?";
				defaultValue = "true";
			};
		};
	};

	class HEDES_AmbientModule_Garrison: HEDES_AmbientModule_BASE
	{
		displayName = "Area Ambient Garrison";
		function = QUOTE(FUNCMAIN(InitAreaAmbientGarrison));

		class Attributes: AttributesBase
		{
			class NumbersofUnits : Edit
			{
				property = "HEDES_AmbientModule_NumOfUnits";
				displayName = "Number of Garrisoned Units";
				tooltip = "Number of units that are garrisoned here.";
				defaultValue = """5""";
			};

			class UnitPool
			{
				property = "HEDES_AmbientModule_UnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types that will spawn as garrison.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only infantry allowed.";
				defaultValue = """['CUP_O_TK_SpecOps','CUP_O_TK_INS_Soldier_GL','CUP_O_TK_INS_Soldier_Enfield','CUP_O_TK_INS_Soldier_MG']""";
				expression = "_this setVariable ['%s',_value];";
			};	

			class GarrisonSide : Combo
			{
				property = "HEDES_AmbientModule_UnitSide";
				displayName = "Garrison Side";
				tooltip = "The type of mission manager used.";
				defaultValue = """EAST""";
				
				class Values
				{
					class east	{
						name = "EAST"; 
						value = "EAST";
					};
					class guer	{
						name = "GUER"; 
						value = "GUER";
					};
					class west	{
						name = "WEST"; 
						value = "WEST";
					};
				};
			};
		};
	};
};
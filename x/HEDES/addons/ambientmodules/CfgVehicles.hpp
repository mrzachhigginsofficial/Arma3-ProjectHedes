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

	class HEDES_AmbientModule_BASE : Module_F
	{
		category = "HEDES_AmbientModules";
		displayName = "Ambient Modules Base (Empty)";
		functionPriority = 1;
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
				defaultValue = """['O_G_Offroad_01_Armed_F']""";
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
				defaultValue = """['C_man_polo_1_F_afro','C_man_polo_2_F_afro','C_man_polo_3_F_afro','C_man_polo_4_F_afro','C_man_polo_5_F_afro','C_man_p_beggar_F_afro']""";
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

	class HEDES_AmbientModule_EmptyVehicles: HEDES_AmbientModule_BASE
	{
		displayName = "Empty Vehicles Module";
		function = QUOTE(FUNCMAIN(InitEmptyVehicles));
		canSetArea=1;
		isGlobal=0;
		isTriggerActivated=1;

		class AttributeValues
		{
			size3[]={50,50,-1};
		};
		
		class ModuleDescription : ModuleDescription
		{
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

		class Attributes: AttributesBase
		{
			class NumOfVehs : Edit
			{
				property = "HEDES_AmbientModule_NumOfVehs";
				displayName = "Number of Vehicles";
				tooltip = "Number of empty vehicles that can be in the area at one time.";
				defaultValue = """5""";
			};

			class UnitPool
			{
				property = "HEDES_AmbientModule_VehPool";
				control = "EditCodeMulti5";
				displayName = "Array of vehicle types that will spawn empty.";
				tooltip = "Array of vehicle types. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles allowed.";
				defaultValue = """['I_G_Van_01_transport_F','I_G_Offroad_01_Repair_F']""";
				expression = "_this setVariable ['%s',_value];";
			};	
		};
	};

	class HEDES_AmbientModule_Garrison : HEDES_AmbientModule_BASE
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
				defaultValue = """['O_G_soldier_LAT_F','O_G_soldier_M_F','O_G_soldier_GL_F']""";
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
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

	class GVAR(AmbientModule_BASE) : Module_F
	{
		canSetArea=1;
		category = QUOTE(GVAR(AmbientModules));
		functionPriority = 1;
		isTriggerActivated = 0;
		scope = 1;

		class AttributeValues
		{
			size3[]={50,50,-1};
		};

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(AmbientModule_Units));
			};

			class SpeedMode : Combo
			{
				property = "HEDES_AmbientModule_SpeedMode";
				displayName = "Speed Mode";
				tooltip = "The units speed.";
				defaultValue = """Limited""";

				class Values
				{
					class Limited	{
						name = "Limited"; 
						value = "Limited";
					};
					class Normal	{
						name = "Normal"; 
						value = "Normal";
					};
					class Full	{
						name = "Full"; 
						value = "Full";
					};
				};
			};

			class UnitSide : Combo
			{
				property = "HEDES_AmbientModule_UnitSide";
				displayName = "Units Side";
				tooltip = "The Spawned Unit Side.";
				defaultValue = """EAST""";
				
				class Values
				{
					class east	{
						name = "EAST"; 
						value = "EAST";
					};
					class guer	{
						name = "GUER"; 
						value = "INDEPENDENT";
					};
					class west	{
						name = "WEST"; 
						value = "WEST";
					};
				};
			};

			class UnitCombatBehaviour : Combo
			{
				property = "HEDES_AmbientModule_UnitBehaviour";
				displayName = "Unit AI Behaviour";
				tooltip = "The Spawned Units Default Behaviour.";
				defaultValue = """SAFE""";
				
				class Values
				{
					class careless	{
						name = "CARELESS (Not Recommended)"; 
						value = "CARELESS";
					};
					class safe	{
						name = "SAFE"; 
						value = "SAFE";
					};
					class aware	{
						name = "AWARE"; 
						value = "AWARE";
					};
					class combat	{
						name = "COMBAT"; 
						value = "COMBAT";
					};
					class stealth	{
						name = "STEALTH"; 
						value = "STEALTH";
					};
				};
			};


			class UnitCombatTask : Combo
			{
				property = "HEDES_AmbientModule_UnitCombatTask";
				displayName = "AI's Task Type";
				tooltip = "What will the AI do.";
				defaultValue = """CBA - Waypoint Garrison""";
				
				class Values
				{
					class cba_defend {
						name = "CBA - Defend"; 
						value = "CBA - Defend";
					};
					class cba_patrol {
						name = "CBA - Patrol"; 
						value = "CBA - Patrol";
					};
					class cba_wpgarrison {
						name = "CBA - Waypoint Garrison"; 
						value = "CBA - Waypoint Garrison";
					};
					class bis_defend {
						name = "BIS - Defend"; 
						value = "BIS - Defend";
					};
					class bis_patrol {
						name = "BIS - Patrol"; 
						value = "BIS - Patrol";
					};
				};
			};

			class SimulationDelay : Edit
			{
				property = "HEDES_AmbientModule_SimDelay";
				defaultValue = "15";
				displayName = "Dynamic Simulation Start Delay";
				tooltip = "Number of seconds until HEDES dynamic simulation kicks in (recommend higher values for garrisons).";
				typeName = "NUMBER";
				validate = "number";
			};

			class NumberOfUnits : Edit
			{
				property = "HEDES_AmbientModule_NumOfUnits";
				displayName = "Number of units/vehicles.";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "5";
				typeName = "NUMBER";
				validate = "number";
			};

			class UnitPool
			{
				property = "HEDES_AmbientModule_UnitPool";
				control = "EditCodeMulti3";
				displayName = "Array of unit types that will spawn.";
				tooltip = "Array of cfgvehicles to spawn. Must be formatted as array: ['var1','var2'].";
				defaultValue = """['vehicle_1_F','vehicle_2_F','vehicle_3_F']""";
				expression = "_this setVariable ['%s',_value];";
			};			

			class UnitInit
			{
				property = "HEDES_AmbientModule_UnitInit";
				control = "EditCodeMulti5";
				displayName = "Unit Init Function (_this refers to the spawned unit).";
				tooltip = "Spawn unit passed as _this (group _this, vehicle _this, removebackpack _this, etc.). This function is only called on unit spawn.";
				expression = "_this setVariable ['%s',_value];";
			};			
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";

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

	class GVAR(AmbientModule_AreaVehPatrol): GVAR(AmbientModule_BASE)
	{
		displayName = "Area Vehicle Patrol (Roads)";
		function = QUOTE(FUNCMAIN(InitAreaPatrollingVehicles));
		scope = 2;
	};

	class GVAR(AmbientModule_Garrison) : GVAR(AmbientModule_BASE)
	{
		displayName = "Area Ambient Garrison";
		function = QUOTE(FUNCMAIN(InitAreaAmbientGarrison));
		scope = 2;

		class Attributes: Attributes
		{
			class GarrisonSide : UnitSide { };
			class NumbersofUnits : NumberOfUnits { };
			class UnitCombatTask : UnitCombatTask { };
			class UnitCombatBehaviour : UnitCombatBehaviour { };
			class SpeedMode : SpeedMode { };
			class SimulationDelay : SimulationDelay { };
			class Units: Units { } ;
			class UnitPool : UnitPool
			{
				displayName = "Array of unit types that will spawn as garrison.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only infantry allowed.";
				defaultValue = """['O_G_soldier_LAT_F','O_G_soldier_M_F','O_G_soldier_GL_F']""";
			};
			class UnitInit : UnitInit { };			
		};
	};
	
	class GVAR(AmbientModule_Civilians) : GVAR(AmbientModule_BASE)
	{
		displayName = "Area Ambient Civs";
		function = QUOTE(FUNCMAIN(InitAreaAmbientCivs));
		scope = 2;

		class Attributes: Attributes
		{
			class NumbersofCivs : NumberOfUnits { };
			class Units: Units { } ;
			class UnitPool : UnitPool
			{
				displayName = "Array of unit types that will spawn as civilians.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only infantry allowed.";
				defaultValue = """['C_man_polo_1_F_afro','C_man_polo_2_F_afro','C_man_polo_3_F_afro','C_man_polo_4_F_afro','C_man_polo_5_F_afro','C_man_p_beggar_F_afro']""";
			};
			class UnitInit : UnitInit { };
		};
	};

	class GVAR(AmbientModule_EmptyVehicles) : GVAR(AmbientModule_BASE)
	{
		displayName = "Empty Vehicles Module";
		function = QUOTE(FUNCMAIN(InitEmptyVehicles));
		scope = 2;

		class Attributes: Attributes
		{
			class NumOfVehs : NumberOfUnits { };
			class Units: Units { } ;
			class UnitPool : UnitPool
			{
				displayName = "Array of vehicle types that will spawn empty.";
				tooltip = "Array of vehicle types. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles allowed.";
				defaultValue = """['I_G_Van_01_transport_F','I_G_Offroad_01_Repair_F']""";
			};	
			class UnitInit : UnitInit { };
		};
	};
};
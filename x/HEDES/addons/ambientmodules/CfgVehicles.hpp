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

	class GVAR(BASE) : Module_F
	{
		canSetArea=1;
		category = QUOTE(GVAR(COMPONENT));
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
				property = QUOTE(GVAR(Units));
			};
			class SpeedMode : Combo
			{
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
					class cba_searchnearby {
						name = "CBA - Search Nearby"; 
						value = "CBA - Search Nearby";
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
			class SliderTimerRespawnBase
			{
				control = "SliderTimeRespawn";
				expression = "_this setVariable ['%s',_value];";
				typeName = "NUMBER";
				validate = "number";
			};
			class EditNumBase : Edit
			{
				typeName = "NUMBER";
				validate = "number";
			};
			class EditCodeMulti3Base
			{
				control = "EditCodeMulti3";
				expression = "_this setVariable ['%s',_value];";
				defaultValue = """true""";
			};			
			class EditCodeMulti5Base
			{
				control = "EditCodeMulti5";
				expression = "_this setVariable ['%s',_value];";
				defaultValue = """true""";
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

	class GVAR(AreaVehPatrol): GVAR(BASE)
	{
		displayName = "Area Vehicle Patrol (Roads)";
		function = QUOTE(FUNCMAIN(InitAreaPatrollingVehicles));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextGlobalDocLink
			{
				property = "StructuredTextGlobalDocLink";
				control = "StructuredText2";
				description = "<t size='1.5'><a href='https://github.com/mrzachhigginsofficial/Arma3-ProjectHedes/wiki/Module-Ambient-Vehicle-Patrols'>Link: Ambient Vehicle Patrols Documentation</a></t>";
			};
			class UnitSide : UnitSide {
				property = "UnitSide";
			};
			class NumberOfVehicles : EditNumBase {
				property = "NumberOfVehicles";
				displayName = "Number of units/vehicles.";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "5";
			};
			class Units : Units { } ;
			class VehicleSpeed : Edit 
			{
				property = "HEDES_AmbientModule_VehSpeed";
				displayName = "Vehicle Speed";
				tooltip = "Speed of Vehicle (50 and below is a nice choice)";
				defaultValue = """25""";
			};
			class UnitPool : EditCodeMulti3Base
			{
				property = "UnitPool";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['O_G_Offroad_01_Armed_F']""";
			};
			class SimulationDelay : SliderTimerRespawnBase
			{
				property = "SimulationDelay";
				defaultValue = "15";
				displayName = "Dynamic Simulation Start Delay";
				tooltip = "Number of seconds until HEDES dynamic simulation kicks in (recommend higher values for garrisons).";
			};
			class SimulationInterval : SliderTimerRespawnBase
			{
				property = "SimulationInterval";
				defaultValue = "30";
				displayName = "Simulation Interval";
				tooltip = "Number of seconds between each iteration of simulation loop.";
			};
			class UnitInit : EditCodeMulti5Base {
				property = "UnitInit";
				displayName = "Unit Init Function.";
				tooltip = "Expression executed with spawned unit passed as _this (group _this, vehicle _this, removebackpack _this, etc.).";
			};			
		};
	};

	class GVAR(Garrison) : GVAR(BASE)
	{
		displayName = "Area Ambient Garrison";
		function = QUOTE(FUNCMAIN(InitAreaAmbientGarrison));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextGlobalDocLink
			{
				property = "StructuredTextGlobalDocLink";
				control = "StructuredText2";
				description = "<t size='1.5'><a href='https://github.com/mrzachhigginsofficial/Arma3-ProjectHedes/wiki/Module---Ambient-Garrison'>Link: Ambient Garrison Documentation</a></t>";
			};
			class GarrisonSide : UnitSide {
				property = "UnitSide";
			};
			class NumbersofUnits : EditNumBase {
				property = "NumberOfVehicles";
				displayName = "Number of units/vehicles.";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "5";
			};
			class UnitCombatTask : UnitCombatTask {
				property = "UnitCombatTask";
			};
			class UnitCombatBehaviour : UnitCombatBehaviour {
				property = "UnitCombatBehaviour";
			};
			class SpeedMode : SpeedMode {
				property = "SpeedMode";
			};
			class SimulationDelay : SliderTimerRespawnBase {
				property = "SimulationDelay";
				defaultValue = "15";
				displayName = "Dynamic Simulation Start Delay";
				tooltip = "Number of seconds until HEDES dynamic simulation kicks in (recommend higher values for garrisons).";
			};
			class SimulationInterval : SliderTimerRespawnBase
			{
				property = "SimulationInterval";
				defaultValue = "30";
				displayName = "Simulation Interval";
				tooltip = "Number of seconds between each iteration of simulation loop.";
			};
			class OrderRefreshInterval : SliderTimerRespawnBase
			{
				property = "OrderRefreshInterval";
				defaultValue = "300";
				displayName = "Patrol/Search Refresh Interval";
				tooltip = "Sometimes units get stuck. Define the interval in which orders are refreshed for these units. Particularly useful with Search Area task.";
			};
			class Units: Units { } ;
			class UnitPool : EditCodeMulti3Base
			{
				property = "UnitPool";
				displayName = "Array of unit types that will spawn as garrison.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only infantry allowed.";
				defaultValue = """['O_G_soldier_LAT_F','O_G_soldier_M_F','O_G_soldier_GL_F']""";
			};		
			class UnitInit : EditCodeMulti5Base {
				property = "UnitInit";
				displayName = "Unit Init Function.";
				tooltip = "Expression executed with spawned unit passed as _this (group _this, vehicle _this, removebackpack _this, etc.).";
			};				
		};
	};
	
	class GVAR(Civilians) : GVAR(BASE)
	{
		displayName = "Area Ambient Civs";
		function = QUOTE(FUNCMAIN(InitAreaAmbientCivs));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextGlobalDocLink
			{
				property = "StructuredTextGlobalDocLink";
				control = "StructuredText2";
				description = "<t size='1.5'><a href='https://github.com/mrzachhigginsofficial/Arma3-ProjectHedes/wiki/Module-Ambient-Civilians'>Link: Ambient Civilians Documentation</a></t>";
			};
			class NumbersofCivs : EditNumBase {
				property = "NumbersofCivs";
				displayName = "Number of units/vehicles.";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "5";
			};
			class SimulationInterval : SliderTimerRespawnBase
			{
				property = "SimulationInterval";
				defaultValue = "30";
				displayName = "Simulation Interval";
				tooltip = "Number of seconds between each iteration of simulation loop.";
			};
			class Units: Units { } ;
			class UnitPool : EditCodeMulti3Base
			{
				property = "UnitPool";
				displayName = "Array of unit types that will spawn as civilians.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only infantry allowed.";
				defaultValue = """['C_man_polo_1_F_afro','C_man_polo_2_F_afro','C_man_polo_3_F_afro','C_man_polo_4_F_afro','C_man_polo_5_F_afro','C_man_p_beggar_F_afro']""";
			};	
			class UnitInit : EditCodeMulti5Base {
				property = "UnitInit";
				displayName = "Unit Init Function.";
				tooltip = "Expression executed with spawned unit passed as _this (group _this, vehicle _this, removebackpack _this, etc.).";
			};		
		};
	};

	class GVAR(EmptyVehicles) : GVAR(BASE)
	{
		displayName = "Empty Vehicles Module";
		function = QUOTE(FUNCMAIN(InitEmptyVehicles));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextGlobalDocLink
			{
				property = "StructuredTextGlobalDocLink";
				control = "StructuredText2";
				description = "<t size='1.5'><a href='https://github.com/mrzachhigginsofficial/Arma3-ProjectHedes/wiki/Module-Ambient-Empty-Vehicles'>Link: Ambient Empty Vehicles Documentation</a></t>";
			};
			class NumOfVehs : EditNumBase {
				property = "NumberOfVehicles";
				displayName = "Number of units/vehicles.";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "5";
			};
			class SimulationInterval : SliderTimerRespawnBase
			{
				property = "SimulationInterval";
				defaultValue = "30";
				displayName = "Simulation Interval";
				tooltip = "Number of seconds between each iteration of simulation loop.";
			};
			class Units: Units { } ;
			class UnitPool : EditCodeMulti3Base
			{
				property = "UnitPool";
				displayName = "Array of vehicle types that will spawn empty.";
				tooltip = "Array of vehicle types. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles allowed.";
				defaultValue = """['I_G_Van_01_transport_F','I_G_Offroad_01_Repair_F']""";
			};	
			class UnitInit : EditCodeMulti5Base {
				property = "UnitInit";
				displayName = "Unit Init Function.";
				tooltip = "Expression executed with spawned unit passed as _this (group _this, vehicle _this, removebackpack _this, etc.).";
			};		
		};
	};

	// -- Duplicate Modules That Are Hidden Because I Used A CBA Pre-Processor Wrong
	class GVAR(AmbientModule_EmptyVehicles) : GVAR(EmptyVehicles) { scope = 1; };
	class GVAR(AmbientModule_Civilians) : GVAR(Civilians) { scope = 1; };
	class GVAR(AmbientModule_Garrison) : GVAR(Garrison) { scope = 1; };
	class GVAR(AmbientModule_AreaVehPatrol) : GVAR(AreaVehPatrol) { scope = 1; };
};
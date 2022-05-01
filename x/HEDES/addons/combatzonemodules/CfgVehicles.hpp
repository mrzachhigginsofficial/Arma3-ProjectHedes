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
		category = QUOTE(GVAR(COMPONENT));
		displayName = "Combat Zone Modules Base (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isGlobal = 2;
		isTriggerActivated = 0;
		scope = 1;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(Units));
			};

			class SliderTimerRespawnBase
			{
				control = "SliderTimeRespawn";
				expression = "_this setVariable ['%s',_value];";
				typeName = "NUMBER";
				validate = "number";
			};

			class StructuredTextChildObj
			{
				property = "StructuredTextChildObj";
				control = "StructuredText6";
				description = "<t size='1.5'>Project Hedes Combat Zone Child Object</t><br/><br/>This is a child object of the Project Hedes Combat Zone Manager Module. Please refer to the documentation link in the modules attribute window for more information.";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";
			sync[] = {"GVAR(BASE)"};

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
	class GVAR(Manager) : GVAR(BASE)
	{
		displayName = "Combat Zone Manager Module";
		function = QUOTE(FUNCMAIN(InitCombatZoneManagerModule));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextGlobalDocLink
			{
				property = "StructuredTextGlobalDocLink";
				control = "StructuredText2";
				description = "<t size='1.5'><a href='https://github.com/mrzachhigginsofficial/Arma3-ProjectHedes/wiki/Combat-Zone-Modules'>Link: Combat Zone Documentation</a></t>";
			};
			class StructuredTextGlobalDescriptions
			{
				property = "StructuredTextGlobalDescriptions";
				control = "StructuredText6";
				description = "<t size='1.5'>Simulation Settings</t><br/>Changing the simulation interval will also affect the rate at which new units are spawned and how frequently sides change their target combat point (if multiple combat point modules are synchronized). Remember, this module is intended to create some interesting events in your scenario and is not intended to be a scenario builder!";
			};
			class DisableDamage : Checkbox
			{
				property = "DisableDamage";
				displayName = "Disable Damage On Heli & Crew";
				tooltip = "Disabling damage helps with eliminating clutter by allowing them to always be forced off field and cleaned up. The down side is, you don't get to shoot them down anymore.";
				defaultValue = "true";
			};
			class UnitsAlwaysPlayObjective : Checkbox
			{
				property = "UnitsAlwaysPlayObjective";
				displayName = "Should Units Always Play Objective";
				tooltip = "Determines whether units should always play the objective. When selected, units will receive new attack orders at the configured simulation interval and always move to current combat point.";
				defaultValue = "true";
			};
			class SimulationInterval : SliderTimerRespawnBase
			{
				property = "SimulationInterval";
				displayName = "Simulation Interval";
				tooltip = "Number of seconds between each iteration of simulation loop.";
				defaultValue = "30";
			};
			class StructuredTextSideDescriptions
			{
				property = "StructuredTextSideDescriptions";
				control = "StructuredText5";
				description = "<t size='1.5'>Combat Zone Side Configurations</t><br/>Each side can also support paradrops from a plane (set 'Is Vehicle Heli?' to false). Beware, paradrops require a very large simulation distance.  Squads are filled with random unit types from the 'Array of Unit Types' array in their respective side. To increase the chance of a specific unit type being spawned, add their config type more than once.";
			};

			// EAST
			class EastVehicle : Edit
			{
				property = "EastVehicle";
				displayName = "(East) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """O_Heli_Light_02_unarmed_F""";
			};
			class EastIsHeli : Checkbox
			{
				property = "EastIsHeli";
				displayName = "Is Vehicle a Heli?";
				tooltip = "Is the vehicle type a helicopter?";
				defaultValue = "true";
			};
			class EastMaxUnits : Edit
			{
				property = "EastMaxUnits";
				displayName = "Maximum Units (East)";
				tooltip = "Maximum number of units for this side.";
				defaultValue = "20";
				validate = "number";
				typeName = "NUMBER";
			};
			class EastUnitPool
			{
				property = "EastUnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['O_soldier_F','O_soldier_PG_F','O_soldier_UAV_F','O_medic_F','O_soldier_SL_F','O_soldier_A_F','O_soldier_LAT_F','O_soldier_AR_F']""";
				expression = "_this setVariable ['%s',_value];";
			};	
			// WEST
			class WestVehicle : Edit
			{
				property = "WestVehicle";
				displayName = "(West) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """I_Heli_light_03_unarmed_F""";
			};
			class WestIsHeli : Checkbox
			{
				property = "WestIsHeli";
				displayName = "Is Vehicle a Heli?";
				tooltip = "Is the vehicle type a helicopter?";
				defaultValue = "true";
			};
			class WestMaxUnits : Edit
			{
				property = "WestMaxUnits";
				displayName = "Maximum Units (West)";
				tooltip = "Maximum number of units for this side.";
				defaultValue = "20";
				validate = "number";
				typeName = "NUMBER";
			};
			class WestUnitPool
			{
				property = "WestUnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['B_medic_F','B_soldier_TL_F','B_soldier_M_F','B_soldier_LAT_F','B_soldier_F','B_soldier_GL_F','B_soldier_A_F','B_soldier_AR_F']""";
				expression = "_this setVariable ['%s',_value];";
			};	
			//GUER
			class GUERVehicle : Edit
			{
				property = "GUERVehicle";
				displayName = "(GUER) Vehicle - Heli or Plane";
				tooltip = "Name of the vehicle that will transport units.";
				defaultValue = """I_Heli_light_03_F""";
			};
			class GUERIsHeli : Checkbox
			{
				property = "GUERIsHeli";
				displayName = "Is Vehicle a Heli?";
				tooltip = "Is the vehicle type a helicopter?";
				defaultValue = "true";
			}
			class GUERMaxUnits : Edit
			{
				property = "GUERMaxUnits";
				displayName = "Maximum Units (GUER)";
				tooltip = "Maximum number of units for this side.";
				defaultValue = "20";
				validate = "number";
				typeName = "NUMBER";
			};
			class GUERUnitPool
			{
				property = "GUERUnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['I_soldier_TL_F','I_medic_F','I_soldier_AT_F','I_soldier_AR_F','I_soldier_TL_F','I_soldier_AA_F','I_soldier_A_F']""";
				expression = "_this setVariable ['%s',_value];";
			};	
		};
	};

	class GVAR(Point) : GVAR(BASE)
	{
		canSetArea=1;
		displayName = "Combat Zone Point Module";
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextChildObj: StructuredTextChildObj { };
		};
	};

	class GVAR(EastLZ) : GVAR(BASE)
	{
		canSetArea=1;
		displayName = "East Landing Zone";
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextChildObj: StructuredTextChildObj { };
		};
	};

	class GVAR(WestLZ) : GVAR(BASE)
	{
		canSetArea=1;
		displayName = "West Landing Zone";
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextChildObj: StructuredTextChildObj { };
		};
	};

	class GVAR(GuerLZ) : GVAR(BASE)
	{
		canSetArea=1;
		displayName = "Independent Landing Zone";
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextChildObj: StructuredTextChildObj { };
		};
	};

	class GVAR(WestSpawn) : GVAR(BASE)
	{
		canSetArea=1;
		displayName = "West Spawn Point Module";
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextChildObj: StructuredTextChildObj { };
		};
	};

	class GVAR(EastSpawn) : GVAR(BASE)
	{
		canSetArea=1;
		displayName = "East Spawn Point Module";
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextChildObj: StructuredTextChildObj { };
		};
	};

	class GVAR(GuerSpawn) : GVAR(BASE)
	{
		canSetArea=1;
		displayName = "Independent Spawn Point Module";
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextChildObj: StructuredTextChildObj { };
		};
	};
};
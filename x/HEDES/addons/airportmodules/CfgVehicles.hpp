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
		category = QUOTE(GVAR(AirportModules));
		functionPriority = 1;
		isTriggerActivated = 0;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(AirportModules_Units));
			};

			class EditMulti3 
			{
				property = "HEDES_AirportModule_EditMulti3";
				control = "EditCodeMulti3";				
				expression = "_this setVariable ['%s',_value];";
			}

			class EditMulti5
			{
				property = "HEDES_AirportModule_EditMulti5";
				control = "EditCodeMulti5";				
				expression = "_this setVariable ['%s',_value];";
			};			

			class Slider
			{
				property = "HEDES_AirportModule_Slider";
				control = "Slider";
				expression = "_this setVariable ['%s',_value];";
			};			

			class UnitInit
			{
				property = "HEDES_AirportModule_UnitInit";
				control = "EditCodeMulti3";
				expression = "_this setVariable ['%s',_value];";
			};			

			class EditNumber : Edit
			{
				property = "HEDES_AirportModule_EditNumber";
				typeName = "NUMBER";
				validate = "number";
			};

			class UnitSide : Combo
			{
				property = "HEDES_AirportModule_UnitSide";
				displayName = "Units Side";
				tooltip = "The Spawned Unit Side.";
				defaultValue = """WEST""";
				
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

			class MissionType : Combo
			{
				property = "HEDES_AirportModule_Mission";
				displayName = "Units Mission";
				tooltip = "The Spawned Units Mission.";
				defaultValue = """Ambient""";
				
				class Values
				{
					class Ambient	{
						name = "Ambient"; 
						value = "Ambient";
					};
					class Patrol	{
						name = "Patrol"; 
						value = "Patrol";
					};
				};
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";
		};
	};

	class GVAR(Aircraft): GVAR(BASE)
	{
		canSetArea=0;
		displayName = "Ambient Airplane Sim (Early Access)";
		function = QUOTE(FUNCMAIN(InitAirportManager));
		scope = 2;

		class Attributes: Attributes
		{
			class NumberOfUnits : EditNumber {
				property = "HEDES_AirportModule_NumOfUnits";
				displayName = "Number of units/vehicles";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "3";
			};
			class UnitSide : UnitSide { };
			class MissionType : MissionType { };
			class MaxFuel : Slider { 
				property = "HEDES_AirportModule_MaxFuel";
				displayName = "Max Fuel (when spawned/reset)";
				tooltip = "How much fuel will be added to the plae (controls flight time).";
				defaultValue = ".5";
			};
			class MinFuel : Slider {
				property = "HEDES_AirportModule_MinFuel";
				displayName = "Min Fuel (when recalled)";
				tooltip = "How much fuel when plane is recalled to airport.";
				defaultValue = ".25";
			}
			class UnitPool : EditMulti3 {
				displayName = "Array of unit types";
				defaultValue = """['B_Plane_CAS_01_dynamicLoadout_F','B_Plane_Fighter_01_F']""";
				property = "HEDES_AirportModule_UnitPool";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";				
			};
			class WPRadius : EditNumber {
				property = "HEDES_AirportModule_RPRadius";
				displayName = "WP Radius";
				tooltip = "Make this bigger if the aircraft doesn't seem to be triggering waypoints.";
				defaultValue = "100";
			};
			class UnitTimeout : EditNumber {
				property = "HEDES_AirportModule_Timeout";
				displayName = "Unit State Timeout";
				tooltip = "How long until a unit is considered bugged and deleted.";
				defaultValue = "240";
			};
			class UnitInit : EditMulti5 {
				property = "HEDES_AirportModule_UnitInit";
				displayName = "Unit Init Function";
				tooltip = "Expression called after new jet/group spawned. Script parameters, [_jet, _grp]: _jet = _this # 0; _grp = _this # 1;... or include params['_jet','_grp'].";
			};			
		};
	};

	class GVAR(Cleaner): GVAR(BASE)
	{
		canSetArea=1;
		displayName = "Ambient Airport Cleaner (WIP)";
		scope = 2;

		class AttributeValues
		{
			size3[]={50,50,-1};
			isRectangle=1;
		};

		class Attributes: Attributes { };
	};

	class GVAR(SpawnPoint): GVAR(BASE)
	{
		canSetArea=0;
		displayName = "Ambient Airport Spawn Point (WIP)";
		scope = 2;

		class Attributes: Attributes { };
	};

	class GVAR(DespawnPoint): GVAR(BASE)
	{
		canSetArea=0;
		displayName = "Ambient Airport Despawn Point (WIP)";
		scope = 2;

		class Attributes: Attributes { };
	};
};
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

	class GVAR(DestructionModule_BASE) : Module_F
	{
		canSetArea=1;
		category = QUOTE(GVAR(DestructionModules));
		functionPriority = 1;
		isTriggerActivated = 0;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(DestructionModules_Units));
			};

			class UnitPool
			{
				property = "HEDES_DestructionModule_UnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types that will spawn.";
				tooltip = "Array of cfgvehicles to spawn. Must be formatted as array: ['var1','var2'].";
				defaultValue = """['B_Plane_CAS_01_dynamicLoadout_F','B_Plane_Fighter_01_F']""";
				expression = "_this setVariable ['%s',_value];";
			};			

			class UnitInit
			{
				property = "HEDES_DestructionModule_UnitInit";
				control = "EditCodeMulti5";
				displayName = "Unit Init Function.";
				tooltip = "Spawn unit passed as _this (group _this, vehicle _this, removebackpack _this, etc.).";
				defaultValue = "_this setdamage 0";
				expression = "_this setVariable ['%s',_value];";
			};			

			class WPRadius : Edit
			{
				property = "HEDES_DestructionModule_RPRadius";
				displayName = "WP Radius.";
				tooltip = "Make this bigger if the aircraft doesn't seem to be triggering waypoints.";
				defaultValue = "100";
				typeName = "NUMBER";
				validate = "number";
			};

			class NumberOfUnits : Edit
			{
				property = "HEDES_DestructionModule_NumOfUnits";
				displayName = "Number of units/vehicles.";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "3";
				typeName = "NUMBER";
				validate = "number";
			};

			class UnitTimeout : Edit
			{
				property = "HEDES_DestructionModule_Timeout";
				displayName = "Unit State Timeout.";
				tooltip = "How long until a unit is considered bugged and deleted.";
				defaultValue = "240";
				typeName = "NUMBER";
				validate = "number";
			};

			class UnitSide : Combo
			{
				property = "HEDES_DestructionModule_UnitSide";
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
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";
		};
	};

	class GVAR(DestructionModule_Aircraft): GVAR(DestructionModule_BASE)
	{
		displayName = "Ambient Airplane Sim (Early Access)";
		function = QUOTE(FUNCMAIN(InitDestructionManager));
		scope = 2;

		class Attributes: Attributes
		{
			class NumberOfUnits : NumberOfUnits { };
			class UnitSide : UnitSide { };
			class UnitPool : UnitPool
			{
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['B_Plane_CAS_01_dynamicLoadout_F','B_Plane_Fighter_01_F']""";
			};
			class WPRadius : WPRadius { };
			class UnitTimeout : UnitTimeout { };
			class UnitInit : UnitInit { };			
		};
	};
};
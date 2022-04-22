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

	class GVAR(AirportModule_BASE) : Module_F
	{
		canSetArea=1;
		category = QUOTE(GVAR(AirportModules));
		functionPriority = 1;
		isTriggerActivated = 0;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(AirportModules_Units));
			};

			class UnitPool
			{
				property = "HEDES_AirportModule_UnitPool";
				control = "EditCodeMulti5";
				displayName = "Array of unit types that will spawn.";
				tooltip = "Array of cfgvehicles to spawn. Must be formatted as array: ['var1','var2'].";
				defaultValue = """['B_Plane_CAS_01_dynamicLoadout_F','B_Plane_Fighter_01_F']""";
				expression = "_this setVariable ['%s',_value];";
			};			

			class UnitInit
			{
				property = "HEDES_AirportModule_UnitInit";
				control = "EditCodeMulti5";
				displayName = "Unit Init Function.";
				tooltip = "Spawn unit passed as _this (group _this, vehicle _this, removebackpack _this, etc.).";
				defaultValue = "_this setdamage 0";
				expression = "_this setVariable ['%s',_value];";
			};			

			class NumberOfUnits : Edit
			{
				property = "HEDES_AirportModule_NumOfUnits";
				displayName = "Number of units/vehicles.";
				tooltip = "Number of units/vehicles that can be in the area at one time.";
				defaultValue = "3";
				typeName = "NUMBER";
				validate = "number";
			};

			class UnitSide : Combo
			{
				property = "HEDES_AirportModule_UnitSide";
				displayName = "Units Side";
				tooltip = "The Spawned Unit Side.";
				defaultValue = "WEST";
				
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

	class GVAR(AirportModule_Aircraft): GVAR(AirportModule_BASE)
	{
		displayName = "Ambient Airplane Sim";
		function = QUOTE(FUNCMAIN(InitAirportManager));
		scope = 2;

		class Attributes: Attributes
		{
			class NumberOfUnits : NumberOfUnits { };
			class UnitPool : UnitPool { };
			class UnitSide : UnitSide
			{
				displayName = "Array of unit types.";
				tooltip = "Array of units. Must be formatted as array: ['var1','var2']. Types are from CfgVehicles. Only vehicles here, not infantry.";
				defaultValue = """['B_Plane_CAS_01_dynamicLoadout_F','B_Plane_Fighter_01_F']""";
			};
			class UnitInit : UnitInit { };			
		};
	};
};
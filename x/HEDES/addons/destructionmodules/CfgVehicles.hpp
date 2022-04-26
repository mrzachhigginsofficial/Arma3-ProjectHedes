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
		category = QUOTE(GVAR(DestructionModules));

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(DestructionModules_Units));
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";
		};
	};

	class GVAR(Artillery): GVAR(BASE)
	{
		displayName = "Ambient Airplane Sim (Early Access)";
		function = QUOTE(FUNCMAIN(InitDestructionManager));
		scope = 1;

		class Attributes: Attributes
		{
			
		};
	};
};
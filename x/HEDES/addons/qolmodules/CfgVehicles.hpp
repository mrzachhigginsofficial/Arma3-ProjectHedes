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

	class GVAR(BASE) : Module_F
	{
		category = QUOTE(GVAR(COMPONENT));
		functionPriority = 1;
		scope = 1;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(Units));
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the QOL module.";
		};
	};

	class GVAR(FriendlyNamePlates): GVAR(BASE)
	{
		displayName = "Friendly Name Plates";
		function = QUOTE(FUNCMAIN(DrawFriendlyNamePlates));
		scope = 2;
	};
};
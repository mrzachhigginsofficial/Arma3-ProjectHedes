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
		isTriggerActivated = 0;
		scope = 2;

		class Attributes : Attributes 
		{
			class StructuredTextDescription
			{
				property = "StructuredTextDescription";
				control = "StructuredText6";
				description = "<t size='1.5'>Name Plate Module</t><br/><br/>This module adds name plates above friendly units. If you like this module, please let me know in Discord. Otherwise, there are no planned changes.";
			};
		};
	};
};
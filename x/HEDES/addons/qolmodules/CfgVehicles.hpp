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

	class HEDES_QOLModules_BASE : Module_F
	{
		category = "HEDES_QOLModules";
		displayName = "QOL Modules Base (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isGlobal = 2;
		isTriggerActivated 	= 0;
		scope = 2;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = "HEDES_QOLModule_Units";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the QOL module.";
		};
	};

	/* HEDES Persistence Modules */
	class HEDES_QOLModule_FriendlyNamePlates: HEDES_QOLModules_BASE
	{
		displayName = "Friendly Name Plates";
		function = QUOTE(FUNCMAIN(DrawFriendlyNamePlates));
	};
};
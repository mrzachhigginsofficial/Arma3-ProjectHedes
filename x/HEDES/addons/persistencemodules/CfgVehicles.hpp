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

	class HEDES_PersistenceModules_BASE : Module_F
	{
		category = "HEDES_PersistenceModules";
		displayName = "Persistence Modules Base (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isGlobal = 2;
		isTriggerActivated 	= 0;
		scope = 2;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = "HEDES_PersistenceModule_Units";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the persistence module.";
			sync[] = {"HEDES_MissionModule_BASE","HEDES_AmbientModule_BASE"};
		};
	};

	/* HEDES Persistence Modules */
	class HEDES_PersistModule_Loadout: HEDES_PersistenceModules_BASE
	{
		displayName = "Unit Loadout Persistence";
		function = QUOTE(FUNCMAIN(InitPersistenceManager));
	};
};
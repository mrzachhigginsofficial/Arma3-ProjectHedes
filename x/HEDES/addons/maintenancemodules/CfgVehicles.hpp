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

	class HEDES_MaintenanceModule_BASE : Module_F
	{
		category = "HEDES_MaintenanceModules";
		displayName = "Maintenance Manager Base Module (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isGlobal = 2;
		isTriggerActivated 	= 0;
		scope = 2;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = "HEDES_MaintenanceModule_Units";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the maintenance manager module.";
			sync[] = {"HEDES_MaintenanceModule_BASE"};
		};
	};

	/* HEDES Maintenance Modules */

	class HEDES_MaintenanceModules_Cleanup : HEDES_MaintenanceModule_BASE
	{
		displayName = "Cleanup Units Maintenance Module";
		function = QUOTE(FUNCMAIN(InitCleanupSystemModule));
	};

	class HEDES_MaintenanceModules_SafeZone : HEDES_MaintenanceModule_BASE
	{
		displayName = "Cleanup Units Outside of Zone Module";
		function = QUOTE(FUNCMAIN(InitSafeZoneCleanup));
	};
};
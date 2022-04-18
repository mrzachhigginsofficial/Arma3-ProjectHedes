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
		scope = 1;

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
		scope = 2;

		class Attributes: AttributesBase
		{
			class LifeSpanValue : Edit
			{
				property = "HEDES_MaintenanceModules_ObjectLifespan";
				displayName = "Object Lifespawn";
				tooltip = "Sometimes units get lost. Set their max lifetime in seconds.";
				defaultValue = """600""";
			};
		};
	};

	class HEDES_MaintenanceModules_SafeZone : HEDES_MaintenanceModule_BASE
	{
		displayName = "Cleanup Units Outside of Zone Module";
		function = QUOTE(FUNCMAIN(InitSafeZoneCleanup));
		scope = 1;

		class Attributes: AttributesBase
		{
			class SafeZoneMarkerName : Edit
			{
				property = "HEDES_MaintenanceModules_SafeZoneMarkerName";
				displayName = "Safe Zone Marker Name";
				tooltip = "The name of the marker before units are deleted.";
				defaultValue = """Marker Name Here""";
			};
		};
	};
};
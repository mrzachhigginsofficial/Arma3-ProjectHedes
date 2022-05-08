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
		displayName = "Maintenance Manager Base Module (Empty)";
		functionPriority = 1;
		scope = 1;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = QUOTE(GVAR(Units));
			};

			class SliderTimerRespawnBase
			{
				control = "SliderTimeRespawn";
				expression = "_this setVariable ['%s',_value];";
				typeName = "NUMBER";
				validate = "number";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the maintenance manager module.";
			sync[] = {"HEDES_MaintenanceModule_BASE"};
		};
	};

	/* HEDES Maintenance Modules */

	class GVAR(Cleanup) : GVAR(BASE)
	{
		displayName = "Cleanup Units Maintenance Module";
		function = QUOTE(FUNCMAIN(InitCleanupSystemModule));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextGlobalDocLink
			{
				property = "StructuredTextGlobalDocLink";
				control = "StructuredText2";
				description = "<t size='1.5'><a href='https://github.com/mrzachhigginsofficial/Arma3-ProjectHedes/wiki/Module-Unit-Maintenance'>Link: Maintenance Module Documentation</a></t><br/>A note... the maintenance thread is always running. This simply allows you to fine tune the parameters.";
			};
			class LifeSpanValue : SliderTimerRespawnBase
			{
				property = "LifeSpanValue";
				displayName = "Object Lifespawn";
				tooltip = "Sometimes units get lost. Set their max lifetime in seconds.";
				defaultValue = "240";
			};
			class SimulationInterval : SliderTimerRespawnBase
			{
				property = "SimulationInterval";
				displayName = "Simulation Interval";
				tooltip = "Number of seconds between each iteration of simulation loop.";
				defaultValue = "30";
			};
		};
	};

	class GVAR(SafeZone) : GVAR(BASE)
	{
		displayName = "Cleanup Units Outside of Zone Module";
		function = QUOTE(FUNCMAIN(InitSafeZoneCleanup));
		scope = 1;

		class Attributes: Attributes
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
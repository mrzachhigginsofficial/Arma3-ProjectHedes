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

	class HEDES_LoadoutModule_BASE : Module_F
	{
		category = "HEDES_LoadoutModules";
		displayName = "Loadout Base Module (Empty)";
		functionPriority = 1;
		is3DEN = 0;
		isTriggerActivated 	= 0;
		scope = 1;
		isGlobal = 1;

		class Attributes: AttributesBase
		{
			class Units: Units
			{
				property = "HEDES_LoadoutModule_Units";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the loadout module.";
			sync[] = {"HEDES_MaintenanceModule_BASE"};
		};
	};

	/* HEDES Loadout Modules */
	class HEDES_LoadoutModules_StarterKit : HEDES_LoadoutModule_BASE
	{
		scope = 2;
		displayName = "Default Loadout Module";
		function = QUOTE(FUNCMAIN(InitDefaultLoadoutModule));

		class Attributes : AttributesBase
		{
			class DefaultLoadout
			{
				property = "HEDES_LoadoutModules_Kit";
				control = "EditCodeMulti5";
				displayName = "Default Unit Loadout (Output of getUnitLoadout).";
				tooltip = "The kit to be applied to the player interaction with this object(s).";
				defaultValue = """[['CUP_arifle_AK74_Early','','','',['CUP_30Rnd_545x39_AK_M',30],[],''],[],[],['CUP_U_O_RUS_M88_MSV_rolled_up',[['FirstAidKit',1],['CUP_30Rnd_545x39_AK_M',1,30]]],[],[],'H_Bandanna_gry','',[],['ItemMap','','','','','']]""";
				expression = "_this setVariable ['%s',_value];";
			};		
		};
	};
	class HEDES_LoadoutModules_StarterVeh : HEDES_LoadoutModule_BASE
	{
		scope = 2;
		displayName = "Default Vehicle Module";
		function = QUOTE(FUNCMAIN(InitDefaultVehicleModule));

		class Attributes : AttributesBase
		{
			class DefaultVeh : Edit
			{
				property = "HEDES_LoadoutModules_StarterVehType";
				displayName = "Vehicle Name";
				tooltip = "The name of the vehicle to spawn.";
				defaultValue = """CUP_O_TT650_TKA""";
			};
		};
	};
};
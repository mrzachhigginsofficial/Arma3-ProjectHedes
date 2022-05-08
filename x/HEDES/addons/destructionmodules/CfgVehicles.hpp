class CfgVehicles
{
	class Logic;

	/* 3den Modules - Base Classes */
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

			class SliderBase
			{
				control = "Slider";
				expression = "_this setVariable ['%s',_value];";
				typeName = "NUMBER";
				validate = "number";
			};

			class SliderTimerRespawnBase
			{
				control = "SliderTimeRespawn";
				expression = "_this setVariable ['%s',_value];";
				typeName = "NUMBER";
				validate = "number";
			};

			class StructuredText3Base
			{
				control = "StructuredText3";
			};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "This is a short description of the ambient units module.";
		};
	};

	/* 3den Modules - HEDES Modules */
	class GVAR(DestroyTown): GVAR(BASE)
	{
		displayName = "Ambient Destroy Town";
		function = QUOTE(FUNCMAIN(InitDestructionManager));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextAliveBuildings : StructuredText3Base
			{
				property = "StructuredTextAliveBuildings";
				description = "<t size='1.5'>Alive Building Modifications</t><br/>The following configuration properties control the chances of a fire spawning in a building that has not been destoryed.";
			};

			class AliveFireWeight : SliderBase
			{
				property = "AliveFireWeight";
				displayName = "Building fire chance.";
				tooltip = "The chance a fire will be spawned in a damaged (but still alive) building. Each building evaluated seperately.";
				defaultValue = ".5";
			};

			class AliveFirePositionWeight : SliderBase
			{
				property = "AliveFirePositionWeight";
				displayName = "Building position fire chance.";
				tooltip = "Chance of a fire being spawn in each alive (damage building notEqualTo 1) buildings position.";
				defaultValue = ".15";
			};

			class StructuredTextRuinedBuildings : StructuredText3Base
			{
				property = "StructuredTextRuinedBuildings";
				description = "<t size='1.5'>Ruin Building Modifications</t><br/>The following configuration properties control the chances of being being ruined and on fire.";
			};

			class RuinWeight : SliderBase
			{
				property = "RuinWeight";
				displayName = "Convert To Ruin Chance";
				tooltip = "Chance a building in the ruin will be converted to a ruin.";
				defaultValue = ".25";
			};

			class RuinsFireWeight : SliderBase
			{
				property = "RuinsFireWeight";
				displayName = "Chance of fire in a ruined building.";
				tooltip = "The chance a fire will be spawned in a ruined building. Each ruin evaluated seperately.";
				defaultValue = ".5";
			};

			class StructuredGlobalDescriptions : StructuredText3Base
			{
				property = "StructuredGlobalDescriptions";
				description = "<t size='1.5'>Global Destruction Module Settings</t><br/>The following parameters effect all fires/effects spawned by this module.";
			};

			class FlickerLocalLightsOnClient : Checkbox
			{
				property = "FlickerLocalLightsOnClient";
				displayName = "Flicker street lights.";
				tooltip = "Controls whether street lights will flicker intermitently. The same street lights do not flicker on every client at the same time!";
				defaultValue = "true"
			}

			class LargeSmokeWeight : SliderBase
			{
				property = "LargeSmokeWeight";
				displayName = "Chance of large smoke cloud.";
				tooltip = "Set the chance of a large cloud of smoke being spawned on a fire (keep this value low for performance reasons).";
				defaultValue = ".10";
			};

			class SmokeUpdateInterval : SliderTimerRespawnBase
			{
				property = "SmokeUpdateInterval";
				displayName = "Large smoke position change freq.";
				tooltip = "How often large clouds of smoke will change their positions. Creates the effect of drifting clouds of smoke from fires.";
				defaultValue = "25";
			};
		};
	};

	class GVAR(SoundEffectSource): GVAR(BASE)
	{
		displayName = "Sound Effect Source";
		function = QUOTE(FUNCMAIN(InitSoundSource));
		isGlobal = 2;
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextSoundSourceDesc : StructuredText3Base
			{
				property = "StructuredTextSoundSourceDesc";
				description = "<t size='1.5'>Ambient Sound Source</t><br/>Initializes the selected sound source. Change the module area size to create random effects on all client machines. Client machines will NOT play the same audio at the same time.";
			};

			class SoundEffect
			{
				property = "SoundEffect";
				displayName = "Sound Source SFX";
				control = "SoundEffect";
				expression = "_this setVariable ['%s',_value];";
			};
		};
	};

	class GVAR(SearchLight): GVAR(BASE)
	{
		displayName = "SearchLight";
		function = QUOTE(FUNCMAIN(InitSearchLight));
		scope = 2;

		class Attributes: Attributes
		{
			class StructuredTextSearchLightDesc : StructuredText3Base
			{
				property = "StructuredTextSearchLightDesc";
				description = "<t size='1.5'>Ambient Search Lights</t><br/>Warning, this is a proof of concept. It might work, but it's a hack job. If you know how to mod and want to help, go to the github, check the source, then reach out to me.";
			};
		};
	};
};
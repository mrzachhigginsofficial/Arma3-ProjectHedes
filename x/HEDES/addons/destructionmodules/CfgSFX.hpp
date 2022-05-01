/*
Sound Definition Format
The sound definitions as well as empty[] param all have the following format:

{soundPath, soundVolume, soundPitch, maxDistance, probability, minDelay, midDelay, maxDelay}
soundPath String - the path to the sound file. In mission config, this is relative to the mission folder
soundVolume Number - the standard definition of sound volume
soundPitch Number - sound pitch, 1 - normal pitch.
maxDistance Number - how far the sound is heard
probability Number - how often the sound is chosen randomly. Range (0-1)
minDelay, midDelay, maxDelay Numbers - time to wait before playing next sound (or the same sound in the loop). The result is calculated according to Gaussian distribution, see random Alt Syntax
Note that probability is ignored when defined in empty[] param.
*/

class CfgSFX
{
	class SirenChicagoTornado
	{
		name = "_HEDES - Broken Chicago Tornado Siren";
		sound0[] = {"x\HEDES\addons\destructionmodules\sounds\siren_chicagotornado.ogg", db-10, 1.0, 600, 1, 0, 0, 0};
		sounds[] = {sound0};
		empty[] = {"x\HEDES\addons\destructionmodules\sounds\siren_chicagotornado.ogg", db-10, 1.0, 600, 1, 0, 0, 0};
	};
	class SirenLvivBombAlert
	{
		name = "_HEDES - Lviv Air Raid Alert";
		sound0[] = {"x\HEDES\addons\destructionmodules\sounds\siren_lvivbombalert.ogg", db20, 1.0, 600, 1, 0, 0, 0};
		sounds[] = {sound0};
		empty[] = {"x\HEDES\addons\destructionmodules\sounds\siren_lvivbombalert.ogg", db20, 1.0, 600, 1, 0, 0, 0};
	};
};
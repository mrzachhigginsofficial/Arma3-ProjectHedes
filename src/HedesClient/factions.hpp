class CfgEditorCategories
{
    class OJSK
    {
        displayName = "OberJägerSchützeKommandos";
        Priority = 0;
        side = 1;
    };
};


class cfgFactionClasses
{
	class OJSK
	{
		displayName = "OberJägerSchützeKommandos";
		icon = "x\HedesClient\assets\flags\ober_flag.paa";
		priority = 1;
		side = 1;
	};
};


class CfgVehicles
{
	class B_G_Soldier_M_F;
	
	class UnterKomando_1 : B_G_Soldier_M_F
    {
        _generalMacro               = "UnterKomando_1";
        side 						= 1;
        scope 						= 2;
        displayName 				= "UnterKommando";
		faction 					= "OJSK";
        editorCatergory 			= "OJSK";
        editorSubCatergory 			= "Hedes Assets";
        author 						= "ZanchoElGrande";
        weapons[] 					= {"CUP_arifle_AK47_Early","Throw","Put"};
        respawnWeapons[] 			= {"CUP_arifle_AK47_Early","Throw","Put"};
        magazines[] 				= {"CUP_30Rnd_762x39_AK47_M","CUP_30Rnd_762x39_AK47_M"};
        respawnMagazines[] 			= {"CUP_30Rnd_762x39_AK47_M","CUP_30Rnd_762x39_AK47_M"}; 
        linkedItems[] 				= {"V_BandollierB_khk","ItemMap"};
        respawnLinkedItems[] 		= {"V_BandollierB_khk","ItemMap"};
    };
};
class CfgVehicles
{
	class CUP_I_GUE_Soldier_GL;
	
	class UnterKomando_1 : CUP_I_GUE_Soldier_GL
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
        linkedItems[] 				= {"CUP_U_I_GUE_Flecktarn","ItemMap"};
        respawnLinkedItems[] 		= {"CUP_U_I_GUE_Flecktarn","ItemMap"};
    };
};
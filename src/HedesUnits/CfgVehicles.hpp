class CfgVehicles
{
	class CUP_I_GUE_Soldier_03;
	
	class HEDESFreedomFighter : CUP_I_GUE_Soldier_03
    {
        _generalMacro = "Freedom Fighter";
        side = 1;
        scope = 2;
        displayName = "Freedom Fighter";
		faction = "OJSK";
        editorCatergory = "OJSK";
        editorSubCatergory = "Hedes Assets";
        author = "ZanchoElGrande";
        weapons[] = {"CUP_arifle_AK47_Early","Throw","Put"};
        respawnWeapons[] = {"CUP_arifle_AK47_Early","Throw","Put"};
        magazines[] = {"CUP_30Rnd_762x39_AK47_M","CUP_30Rnd_762x39_AK47_M"};
        respawnMagazines[] = {"CUP_30Rnd_762x39_AK47_M","CUP_30Rnd_762x39_AK47_M"}; 
        linkedItems[] = {"CUP_U_I_GUE_Woodland1","ItemMap"};
        respawnLinkedItems[] = {"CUP_U_I_GUE_Woodland1","ItemMap"};
    };
};
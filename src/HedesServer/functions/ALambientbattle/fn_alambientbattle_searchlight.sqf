// by ALIAS
// null = [this,enable_sound] execVM "ALambientbattle\aaa_search_light.sqf"

private ["_search_object"];

if (!isServer) exitWith {};

_search_object	= _this select 0;
_enable_sound	= _this select 1;

if (!isNil {_search_object getVariable "is_ON"}) exitwith {};
_search_object setVariable ["is_ON",true,true];

// make the variable below false on the fly to sremove the search light from your mission
al_search_light = true; publicVariable "al_search_light";

[_search_object,_enable_sound] remoteExec ["HEDESClient_fnc_alambientbattle_searchlight_effect",0,true];
// by ALIAS
// nul = [aaa_object_name] execVM "ALambientbattle\alias_flaks.sqf";

if (!isServer) exitWith {};

_main_air_object = _this select 0;

if (!isNil {_main_air_object getVariable "is_ON"}) exitwith {};
_main_air_object setVariable ["is_ON",true,true];

// make variable below false if you want to stop the loop and remove AAA effect on the fly
al_aaa = true; publicVariable "al_aaa";

[_main_air_object] remoteExec ["HEDESServer_fnc_alambientbattle_flaks_effect",0,true];

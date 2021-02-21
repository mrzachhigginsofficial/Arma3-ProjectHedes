// by ALIAS
// nul = [artillery_object_name] execVM "ALambientbattle\alias_artillery.sqf";

if (!isServer) exitWith {};

private ["_xx","_yy","_zz","_dire"];
_main_art_object = _this select 0;

if (!isNil {_main_art_object getVariable "is_ON"}) exitwith {};
_main_art_object setVariable ["is_ON",true,true];

// make variable below false if you want to stop the loop
al_art = true; publicVariable "al_art";

al_art_sunet_play = false;
publicVariable "al_art_sunet_play";	

[] spawn {while {al_art} do {	sleep 35 + random 2; al_art_sunet_play = false; publicVariable "al_art_sunet_play"}};

[_main_art_object] remoteExec ["HEDESClient_fnc_alambientbattle_artillery_effect",0,true];
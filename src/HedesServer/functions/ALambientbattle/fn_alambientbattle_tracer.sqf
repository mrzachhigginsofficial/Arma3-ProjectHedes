// by ALIAS
// nul = [tracers_object_name,color] execVM "ALambientbattle\alias_tracers.sqf";

private ["_main_tracer_object","_color","_trasor","_xx","_yy","_zz","_life_time_tras"];

if (!isServer) exitWith {};

_main_tracer_object = _this select 0;
_color = _this select 1;

if (!isNil {_main_tracer_object getVariable "is_ON"}) exitwith {};
_main_tracer_object setVariable ["is_ON",true,true];

// make variable below false if you want to stop the loop and remove tracer effect
al_tracer = true; publicVariable "al_tracer";
al_tracers_sunet_play = false; publicVariable "al_tracers_sunet_play";	

[] spawn {while {al_tracer} do {sleep 33 + random 4; al_tracers_sunet_play = false;	publicVariable "al_tracers_sunet_play"}};

[_main_tracer_object,_color] remoteExec ["HEDESClient_fnc_alambientbattle_tracer_effect",0,true];



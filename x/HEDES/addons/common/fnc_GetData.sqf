/*
---------------------------------------------
Get Hash Data
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_namespace", "_hash", "_key"];

if (!isServer) exitWith {};

[(_namespace getvariable _hash), _key] call CBA_fnc_hashGet;
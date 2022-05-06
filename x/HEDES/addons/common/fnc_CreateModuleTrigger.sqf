/*
---------------------------------------------
Creates Trigger From Module Area
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

private _newtrigger = createtrigger ["emptydetector", position _this];
_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
_newtrigger setPos (getPos _this);
_newtrigger enableSimulationGlobal false;

_newtrigger
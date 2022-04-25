/*
---------------------------------------------
Adds NPCs To Draw Name Plate List
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

ISNILS(GVAR(ALLMISSIONGIVERS),[]);

GVAR(ALLMISSIONGIVERS) pushback _this;
publicVariable QGVAR(ALLMISSIONGIVERS);
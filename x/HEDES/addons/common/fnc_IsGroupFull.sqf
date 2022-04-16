/*
---------------------------------------------
Checks If Group Is Full
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params["_pvtgrp", "_pvtmaxunits"];

(count((units _pvtgrp) select {alive _x})) >= _pvtmaxunits;
/*
---------------------------------------------
Looks For Hidden Position
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"

params ["_var",["_radius", true]];

private _sidea = 0;
private _sideb = 0;

if (_var isKindOf "EmptyDetector") then 
{
	_sidea = (triggerArea _var) # 0;
	_sideb = (triggerArea _var) # 1;
} 
else 
{
	_sidea = (_var getVariable "ObjectArea") # 0;
	_sideb = (_var getVariable "ObjectArea") # 1;
};

private _result = if _radius then 
{
	(sqrt((_sidea^2)*(_sideb^2)))/2
} else {
	(sqrt((_sidea^2)*(_sideb^2)))
};

_result
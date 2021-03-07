/*
--------------------------------------------------------------------
Add Unit To Cleanup MissionConfig Global Array

Description:
	Adds unit to list that will be cleaned up.

Notes:
	None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"

private _newarray = missionNameSpace getVariable GLOABLMISSIONCLEANUPQUEUE;

switch (typeName _this) do
{
	case "ARRAY": {
		_newarray append _this;
	};

	case "OBJECT": {
		_newarray pushback _this;
	};
};

missionNamespace setVariable [GLOABLMISSIONCLEANUPQUEUE,_newarray];

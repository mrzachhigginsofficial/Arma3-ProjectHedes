/* 
--------------------------------------------------------------------
Create Destory Task 

Description:
	Create destroy task in random location and return taskname +
    location.

Notes: 
    None

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _result = (_this + ["destory"]) call FUNC(CreateMissionTask);
_result
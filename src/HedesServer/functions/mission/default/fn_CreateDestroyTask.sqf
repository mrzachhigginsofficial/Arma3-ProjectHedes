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

(_this + ["destory"]) call FUNC(CreateMissionTask)
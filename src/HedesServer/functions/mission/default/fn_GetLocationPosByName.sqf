/* 
--------------------------------------------------------------------
Get Location Position 

Description:
	Returns location position base on name and type.

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _locname        = param[0, 'Ile Sainte-Marie'];
private _loctype        = param[1, 'namelocal'];
private _reference      = param[2, [worldSize/2, worldSize/2, 0]];

position ((nearestLocations [_reference, [_loctype], worldSize /2]) select {
    text _x == _locname
} select 0);
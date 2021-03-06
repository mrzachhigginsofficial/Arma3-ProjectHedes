/* 
--------------------------------------------------------------------
Player Transition Script

Description:
	Takes several arguements that are execute remote scripts on then
	target player client machines to perform a camera transition.

Notes: 
    None

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _player 	= param[0,player];
private _type 		= param[1,"fade"];
private _commander  = param[2,"HQ"];
private _text 		= param[3,""];

switch (_type) do
{
	case ('fade'):{
		["OMComputerSystemStart",_text,"BLACK OUT",2] remoteExec [QUOTE(FUNC(cameradeploystart)), owner _player];
	};
	case ('zoom'): {
		[_commander, _text,"radioAmbient5"] remoteExec [QUOTE(FUNC(cameramissionstart)), owner _player];
	};
};
/* 
--------------------------------------------------------------------
Get Mission Arg Properties. 

Description:
    Reads Required Mission Args and returns their values as an array.
    To be passed to a function.
    [arg properties from config] call <function from config>

Notes: 
    None.

Author: ZanchoElGrande

--------------------------------------------------------------------
*/

#include "\x\HEDESServer\macros.h"
if (!isServer) exitWith {};

private _cfgpath        = param[0,configfile >> "CfgHedesMissions" >> "default"];
private _argsname       = param[1,"deploycamargs"];

(getArray(_cfgpath >> _argsname)) apply {
    private _cfg = _cfgpath >> _x;
    private _val = nil;
    switch(true)do{
        case (isNumber _cfg): {_val = getNumber _cfg};
        case (isText _cfg): {_val = getText _cfg};
        case (isArray _cfg): {_val = getArray _cfg};
    };
    _val
}
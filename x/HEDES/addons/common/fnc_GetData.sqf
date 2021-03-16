params [["_tag", nil],["_namespace", missionNamespace]];

private _data = "";

if (isNil {_namespace getVariable _tag}) then { 
	_namespace setVariable [_tag,[] call CBA_fnc_hashCreate];
};

_namespace getVariable _tag; 
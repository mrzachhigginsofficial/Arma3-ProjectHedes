/*
---------------------------------------------
Initialized Ambient Civilian Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];

/*
--------------------------------------------------------------------
Main Thread
--------------------------------------------------------------------
*/

_logic spawn {
    
    // -- Initialize Variables
    private _i = 0;
	private _maxtry = 5;
    private _triggeri = objNull;
    private _grpi = grpNull;
    private _safespawnpos = [0,0];
    private _civunit = objNull;
    private _wppos = [0,0];
    private _moveloc = [0,0];

    // -- Get Module Properties
    private _unitpool = call compile (_this getVariable ["UnitPool","[]"]);
    private _maxcivs = call compile (_this getVariable ["NumbersofCivs","5"]);
    private _bombers = _this getVariable ["SuicideBombers",true]; // Not Used Yet
    private _areatriggers = synchronizedObjects _this select {_x isKindOf "EmptyDetector"} apply {[_x,grpNull]};

	// -- Initialize Default Trigger Area	
	if (count(_areatriggers) == 0) then 
	{
		private _newtrigger = createtrigger ["emptydetector", position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger attachto [_this];
		_areatriggers pushBack [_newtrigger,grpNull];
	};

    // -- THIRD PARTY FUNCTION by phronk
    _civflee = {
        _this # 0 addEventHandler["firedNear", {
            _animation = selectRandom ["ApanPercMstpSnonWnonDnon_G01","ApanPknlMstpSnonWnonDnon_G01","ApanPpneMstpSnonWnonDnon_G01","ApanPknlMstpSnonWnonDnon_G01"];
            [_this, _animation] remoteExec ["switchMove"];
            sleep 2;
            _this setspeedMode "FULL";
            _building = selectRandom (nearestobjects[_this, ["House"], 200]);
            _this domove (selectRandom (_building buildingPos -1));
            _this removeAllEventHandlers "firedNear";
        }];
    };

    // -- Main Loop
    while { _this isNotEqualTo objNull } do 
	{
        if (simulationEnabled _this) then
		{
            // -- Iterate Over Each Trigger Area
            {
                _triggeri = _x # 0;
                _grpi = _x # 1;

                if (simulationEnabled _triggeri) then 
                {
                    // -- Create New Group If Needed. And Probably Investigate Players For Warcrimes
                    if (_grpi isEqualTo grpNull) then 
                    {
                        _grpi = createGroup [CIVILIAN, false];
                        [_grpi, FUNCMAIN(IsPlayersNearGroup)] spawn FUNCMAIN(DynamicSimulation);
                        _x set [1, _grpi];
                    };

                    // -- Refill Units
                    _i = 0;
                    while {!([_grpi, _maxcivs] call FUNCMAIN(IsGroupFull)) && _i < _maxtry} do {
                        _rndpos = [_triggeri, true] call FUNCMAIN(FindHiddenRanPosInMarker);
                        if (_rndpos isNotEqualTo [0,0]) then 
                        {
                            _civunit = _grpi createUnit [selectRandom _unitpool,_rndpos,[],0,"FORM"];
                            _civunit setSpeedMode "LIMITED";
                            {_civunit disableAI  _x} foreach ["SUPPRESSION","MINEDETECTION","CHECKVISIBLE","AIMINGERROR","WEAPONAIM","TARGET","LIGHTS"];
                            [_civunit] call _civflee;
                            [_civunit] call FUNCMAIN(AppendCleanupSystemObjects);
                        };
                        _i = _i + 1;
                    };

                    // -- Keep them walking
                    {	
                        if (simulationEnabled _x) then {
                            _wppos = [getPos _x, 25, 75, 3, 0, 20, 0] call BIS_fnc_findSafePos;
                            switch (selectRandom[1,2]) do {
                                case 1: { 
                                    _moveloc = getPos nearestBuilding _wppos; 
                                };
                                case 2: { 
                                    _roads = _wppos nearRoads 50;
                                    if (count _roads > 0) then {
                                        _moveloc = getPos (selectRandom _roads); 
                                    } else {
                                        _moveloc = getPos nearestBuilding _wppos; 
                                    };						
                                };
                            };		
                            _x doMove _moveloc;
                            _x setSpeedMode "LIMITED";                            
                        };   
                        sleep 1;
                    } foreach (units _grpi);
                };
            } foreach _areatriggers;

            // -- Be Gentle
            sleep 15;
        };
    };
};
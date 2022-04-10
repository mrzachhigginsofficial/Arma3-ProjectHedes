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
THIRD PARTY FUNCTION - https://www.armaholic.com/page.php?id=32139
Author: phronk
--------------------------------------------------------------------
*/
HEDES_3P_CivFlee={
    _this select 0 addEventHandler["firedNear", {
        _civ=_this select 0;
        _animation = selectRandom [
            "ApanPercMstpSnonWnonDnon_G01",
            "ApanPknlMstpSnonWnonDnon_G01",
            "ApanPpneMstpSnonWnonDnon_G01",
            "ApanPknlMstpSnonWnonDnon_G01"
        ];

        _civ setspeedMode "FULL";
        [_civ, _animation] remoteExec ["switchMove"];

        _nH = nearestobjects[_civ, ["House"], 200];
        _H = selectRandom _nH;
        _HP = _H buildingPos -1;
        _HP = selectRandom _HP;
        _civ domove _HP;
        _civ removeAllEventHandlers "firedNear";
    }];
};

/*
--------------------------------------------------------------------
Main Thread
--------------------------------------------------------------------
*/
_logic spawn {
    private _unitpool = call compile (_this getVariable ["UnitPool","[]"]);
    private _maxcivs = call compile (_this getVariable ["NumbersofCivs","5"]);
    private _bombers = _this getVariable ["SuicideBombers",true];
    private _civgroup = createGroup [CIVILIAN, false];

	private _IsGroupFull = {
		params["_pvtgrp", "_pvtmaxunits"];
		(count((units _pvtgrp) select {alive _x})) >= _pvtmaxunits;
	};
    
    // -- All units should be dynamically simulated.
    // -- This custom simulation is because of how the "flee" script works.
    _civgroup spawn {
        while {_this != grpNull} do {
            private _unit = objNull;
            {
                _unit = _x;
                if (count (allPlayers select {(_unit distance _x) < (dynamicSimulationDistance "Group")}) == 0) then {
                    _unit enableSimulationGlobal false;
                } else {
                    _unit enableSimulationGlobal true;
                };
            } foreach (units _this);
            sleep 5;
        };
    };

    while { true } do {

        // -- Refill Unit Pool 
        if !([_civgroup, _maxcivs] call _IsGroupFull) then{
            private _safespawnpos = [getPos _this, 25, 75, 3, 0, 20, 0] call BIS_fnc_findSafePos;
            private _civunit = _civgroup createUnit [selectRandom _unitpool,_safespawnpos,[],0,"FORM"];
            _civunit setSpeedMode "LIMITED";
            _civunit enableDynamicSimulation true;
            _civunit disableAI "SUPPRESSION";
            _civunit disableAI "MINEDETECTION";
            _civunit disableAI "CHECKVISIBLE";
            _civunit disableAI "AIMINGERROR";
            _civunit disableAI "WEAPONAIM";
            _civunit disableAI "TARGET";
            _civunit disableAI "LIGHTS";
            [_civunit] call HEDES_3P_CivFlee;
            [_civunit] call FUNCMAIN(AppendCleanupSystemObjects);
        };

        // -- Keep them walking
        {	
            if (simulationEnabled _x) then {

                private _wppos = [getPos _x, 25, 75, 3, 0, 20, 0] call BIS_fnc_findSafePos;
                private _moveloc = _wppos;

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

        } foreach (units _civgroup);

        sleep 15;
    };
};
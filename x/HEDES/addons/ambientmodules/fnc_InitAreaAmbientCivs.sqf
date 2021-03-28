/*
---------------------------------------------
Initialized Ambient Civilian Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull, [objNull]];
private _unitpool = call compile (_logic getVariable ["UnitPool","[]"]);
private _maxcivs = call compile (_logic getVariable ["NumbersofCivs","5"]);
private _bombers = _logic getVariable ["SuicideBombers",true];

private _civgroup = createGroup [CIVILIAN, false];

/*
--------------------------------------------------------------------
THIRD PARTY FUNCTION - https://www.armaholic.com/page.php?id=32139
Author: phronk
--------------------------------------------------------------------
*/
HEDES_3P_CivFlee={
    _this select 0 addEventHandler["firedNear", {
        _civ=_this select 0;
        switch(round(random 2))do{
            case 0:{
                _civ switchMove "ApanPercMstpSnonWnonDnon_G01";
                _civ setspeedMode "FULL";
            };
            case 1:{
                _civ playMoveNow "ApanPknlMstpSnonWnonDnon_G01";
                _civ setspeedMode "FULL";
            };
            case 2:{
                _civ playMoveNow "ApanPpneMstpSnonWnonDnon_G01";
                _civ setspeedMode "FULL";
            };
            default{
                _civ playMoveNow "ApanPknlMstpSnonWnonDnon_G01";
                _civ setspeedMode "FULL";
            };
        };
        
        _nH = nearestobjects[_civ, ["House"], 200];
        _H = selectRandom _nH;
        _HP = _H buildingPos -1;
        _HP = selectRandom _HP;
        _civ domove _HP;
        _civ removeAllEventHandlers "firedNear";

        _civ call FUNCMAIN(AppendCleanupSystemObjects);
    }];
};

/*
--------------------------------------------------------------------
Main Thread
--------------------------------------------------------------------
*/
while { true } do {

    // -- Refill Unit Pool 
	if (
        (count((units _civgroup) select {alive _x})) < _maxcivs &&
        count(_logic nearEntities ["Man",150] select {_x in allPlayers}) == 0
    ) then{
		private _safespawnpos = [getPos _logic, 25, 75, 3, 0, 20, 0] call BIS_fnc_findSafePos;
		private _civunit = _civgroup createUnit [selectRandom _unitpool,_safespawnpos,[],0,"FORM"];
        _civunit enableDynamicSimulation true;
        _civunit setBehaviour "CARELESS";
        _civunit setSpeedMode "LIMITED";
		[_civunit] call HEDES_3P_CivFlee;
	};

    // -- Keep them walking
    {		
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

        sleep 1;

    } foreach (units _civgroup);

	sleep 15;
};
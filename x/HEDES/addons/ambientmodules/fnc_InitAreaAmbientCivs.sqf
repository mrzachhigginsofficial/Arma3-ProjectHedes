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

    while { true } do {

        // -- Refill Unit Pool 
        if (
            (count((units _civgroup) select {alive _x})) < _maxcivs &&
            count(_this nearEntities ["Man",150] select {_x in allPlayers}) == 0
        ) then{
            private _safespawnpos = [getPos _this, 25, 75, 3, 0, 20, 0] call BIS_fnc_findSafePos;
            private _civunit = _civgroup createUnit [selectRandom _unitpool,_safespawnpos,[],0,"FORM"];
            _civunit enableDynamicSimulation true;
            //_civunit setBehaviour "CARELESS";
            _civunit setSpeedMode "LIMITED";
            [_civunit] call HEDES_3P_CivFlee;
            [_civunit] call FUNCMAIN(AppendCleanupSystemObjects);
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
};
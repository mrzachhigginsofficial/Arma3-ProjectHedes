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
    
    // Initialize Variables
    private _i = 0;
    private _triggeri = objNull;
    private _grpi = grpNull;
    private _safespawnpos = [0,0];
    private _civunit = objNull;
    private _wppos = [0,0];
    private _moveloc = [0,0];
    private _isfirstspawn = 1;

    // Get Module Properties
    private _areatriggers = synchronizedObjects _this select {_x isKindOf "EmptyDetector"} apply {[_x,grpNull]};
    private _interval = _this getVariable ["SimulationInterval",30];
    private _maxcivs = _this getVariable ["NumbersofCivs",5];
	private _newunitinitfnc = compile (_this getVariable ["UnitInit", {}]);
    private _unitpool = call compile (_this getVariable ["UnitPool","[]"]);

	// Initialize Default Trigger Area	
	if (count(_areatriggers) == 0) then 
	{
		private _newtrigger = createtrigger ["emptydetector", position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger setPos (getPos _this);
		_areatriggers pushBack [_newtrigger, grpNull];
	};

    // Disable Simulation on Triggers
    {
        (_x # 0) enableSimulationGlobal false;
    } foreach _areatriggers;

    // THIRD PARTY FUNCTION by phronk
    _civflee = {
        _this addEventHandler["firedNear", {
            _animation = selectRandom ["ApanPknlMstpSnonWnonDnon_G01"];
            _this # 0 playMoveNow _animation;
            _this # 0 setspeedMode "FULL";
            _this # 0 forceWalk false;
            _buildings = (nearestobjects[_this # 0, ["House"], 200]);
            if (count(_buildings) > 0) then 
            {
                _building = selectRandom (nearestobjects[_this # 0, ["House"], 200]);
                _this # 0 domove (selectRandom (_building buildingPos -1));
            };
            _this # 0 spawn {
                while {
                    (allPlayers findIf {[objNull, "VIEW"] checkVisibility [eyePos _x, eyePos _this] > .2}) > -1
                    } do {sleep 5};
                deleteVehicle _this;
            };
            (_this # 0) removeAllEventHandlers "firedNear";
        }];
    };

    // Main Loop
    while { _this isNotEqualTo objNull } do 
	{
        if (simulationEnabled _this) then
		{
            if !(isNil "HEDES_DEBUG") then {systemchat format["%1 fired with interval of %2.",_this, _interval]};

            // Iterate Over Each Trigger Area
            {
                _triggeri = _x # 0;
                _grpi = _x # 1;

                // Create New Group If Needed. And Probably Investigate Players For Warcrimes
                if (_grpi isEqualTo grpNull) then 
                {
                    _grpi = createGroup [CIVILIAN, false];
                    [_grpi, FUNCMAIN(IsPlayersNearGroup)] spawn FUNCMAIN(DynamicSimulation);
                    _x set [1, _grpi];
                };

                // Refill Units
                _i = 0;
                while {!([_grpi, _maxcivs] call FUNCMAIN(IsGroupFull)) && _i < _maxcivs} do {

                    _rndpos = if (_isfirstspawn == 1) then {
                        [_triggeri call BIS_fnc_randomPosTrigger, 0, 5] call BIS_fnc_findSafePos
                    } else {
                        [_triggeri, false, 5] call FUNCMAIN(FindHiddenRanPosInMarker)
                    };
                    
                    if (_rndpos isNotEqualTo [0,0]) then 
                    {
                        _civunit = _grpi createUnit [selectRandom _unitpool,_rndpos,[],0,"FORM"];
                        _civunit setPosATL [(getPosATL _civunit) # 0, (getPosATL _civunit) # 1 ,0];
                        _civunit setSpeedMode "LIMITED";
                        _civunit forceWalk true;
                        {_civunit disableAI  _x} foreach ["SUPPRESSION","MINEDETECTION","CHECKVISIBLE","AIMINGERROR","WEAPONAIM","TARGET","LIGHTS","RADIOPROTOCOL"];
                        _civunit call _civflee;
                        [_civunit] call FUNCMAIN(AppendCleanupSystemObjects);
                        _civunit call _newunitinitfnc;
                    };
                    _i = _i + 1;
                };

                // Keep them walking
                {	
                    if (simulationEnabled _x && (speed _x) < 1) then 
                    {
                        _wppos = [_triggeri, true, 5] call FUNCMAIN(FindRanPosInMarker);
                        if (_wppos isNotEqualTo [0,0]) then 
                        {
                            switch (selectRandom[1,2]) do 
                            {
                                case 1: 
                                { 
                                    _moveloc = getPos nearestBuilding _wppos; 
                                };
                                case 2: 
                                { 
                                    _roads = _wppos nearRoads 50;
                                    if (count _roads > 0) then
                                    {
                                        _moveloc = getPos (selectRandom _roads); 
                                    } else {
                                        _moveloc = getPos nearestBuilding _wppos; 
                                    };						
                                };
                            };		
                            _x doMove _moveloc;
                            _x setSpeedMode "LIMITED";

                            if !(isNil "HEDES_DEBUG") then {
                                ("VR_3DSelector_01_default_F" createVehicle _moveloc) spawn {
                                    sleep 5;
                                    deleteVehicle _this;
                                };
                            };
                        }
                    };   
                } foreach (units _grpi);
            } foreach _areatriggers;

            _isfirstspawn = 0;
        };

        // Go to sleep for a bit.
        sleep _interval;
    };
};
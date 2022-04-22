/*
---------------------------------------------
Initializes Combat Zone Manager Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

_logic spawn {

	// -- Initialize Variables
	private _combatzone = objNull;
	private _pointmodule = objNull;
	private _pointranpos = [0,0];
	private _config = objNull;
	private _groups = [];
	private _combatlz = objNull;
	private _combatlztrgs = [];
	private _combatlzpos = [0,0];
	private _debug_objs = [];


	// -- Build Side Configuration Settings
	private _sideconfigs = [];

	// -- Add East
	private _eastSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_EastSpawn" });
	if(count(_eastSpawns) > 0) then 
	{
		_sideconfigs pushback [EAST,_this getVariable ["EastVehicle",""],_this getVariable ["EastUnitPool",""],getPos (selectRandom _eastSpawns),_this getVariable ["EastIsHeli",true],_this getVariable ["EastMaxUnits",80],[]];
	};

	// -- Add West
	private _westSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_WestSpawn" });
	if(count(_westSpawns) > 0) then 
	{
		_sideconfigs pushback [WEST,_this getVariable ["WestVehicle",""],_this getVariable ["WestUnitPool",""],getPos (selectRandom _westSpawns),_this getVariable ["WestIsHeli",true],_this getVariable ["WestMaxUnits",80],[]]
	};

	// -- Add Independent
	private _guerSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_GuerSpawn" });
	if (count(_guerSpawns) > 0) then 
	{
		_sideconfigs pushback [INDEPENDENT,_this getVariable ["GUERVehicle",""],_this getVariable ["GUERUnitPool",[]],getPos (selectRandom _guerSpawns),_this getVariable ["GUERIsHeli",true],_this getVariable ["GUERMaxUnits",80],[]];
	}; 

	// -- Configure Trigger Area For All Combat Zones & The Same For LZ's
	private _newtrigger = objNull;
	private _createtriggerfnc = {
		_newtrigger = createtrigger ["emptydetector", position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger attachto [_this];
		_newtrigger
	};
	private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" } apply {[_x, objNull]};
	{
		_point = _x;
		_point set [1,(_point # 0) call _createtriggerfnc]; // Attach Trigger To CombatZone
		synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_EastLZ" } apply {_x call _createtriggerfnc}; // Attach Trigger To LZ
		synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_WestLZ" } apply {_x call _createtriggerfnc}; // Attach Trigger To LZ
		synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_GuerLZ" } apply {_x call _createtriggerfnc}; // Attach Trigger To LZ
	} foreach _points;


	// --  Main Loop
	while {_this isNotEqualTo objNull} do 
	{
		if (simulationEnabled _this) then
		{
			// -- Find New Combat Zone Area
			_combatzone = selectRandom (_points select {simulationEnabled (_x select 0)});
			_pointmodule = _combatzone # 0;
			_pointranpos = (_combatzone # 1) call BIS_fnc_randomPosTrigger;
			_pointranpos = [_pointranpos, 0, 10] call BIS_fnc_findSafePos;

			// -- If The Combat Zone Position Is Valid... Continue
			if (_pointranpos isNotEqualTo [0,0]) then 
			{
				// -- Iterate Through Each Side Config
				{				
					_config = _x;	
						
					// -- Filter Out Dead/Null Units
					_config set [6,((_config # 6) - [objNull]) select {alive _x}];	

					// -- Get LZ Module Properties
					_combatlz = switch (_config # 0) do 
					{
						case EAST: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_EastLZ"})};
						case WEST: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_WestLZ"})};
						case INDEPENDENT: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_GuerLZ"})};
					};
									
					// -- Get Combat Zone Landing Area Triggers
					_combatlztrgs = (attachedObjects _combatlz) select {typeOf _x == "emptydetector"};
					_combatlzpos = [0,0];
					if (count(_combatlztrgs) > 0) then 
					{
						_combatlzpos = _combatlztrgs call BIS_fnc_randomPosTrigger;
						_combatlzpos = [_combatlzpos, 0, 10] call BIS_fnc_findSafePos;
					} else {
						_combatlzpos = _pointmodule getRelPos [250, random 360];
					};					

					if !(isNil "HEDES_DEBUG") then 
					{
						_debug_objs pushBack ("VR_3DSelector_01_default_F" createVehicle _combatlzpos);
					};

					// -- Try To Spawn New Units
					if(count(_config # 6) < (_config # 5) && (_combatlzpos isNotEqualTo [0,0])) then
					{
						// -- Spawn Vehicle With Crew and Fireteams
						_groups = [_config # 0, _config # 1, call compile(_config # 2), _config # 3] call FUNCMAIN(SpawnVehicleAndCrew);
						_groups apply {_x allowFleeing 0};
						while {count(units (_groups # 1)) > (_config # 5)} do 
						{
							deleteVehicle (selectRandom units (_groups # 1));
						};
						units(_groups # 0) apply {_x disableAI "SUPPRESSION"};
						units(_groups # 0) apply {_x disableAI "RADIOPROTOCOL"};
						units(_groups # 0) apply {_x disableAI "MINEDETECTION"};

						// -- Setup Unit and Vehicle Orders						
						(_groups + [_combatlzpos, _x # 3, _x # 4]) spawn FUNCMAIN(FlightPlanner);
						[_groups # 1, _pointranpos] call BIS_fnc_taskAttack; 

						// -- Add Units To Cleanup
						[_groups # 1, FUNCMAIN(IsPlayersNearGroup),_x # 4] spawn FUNCMAIN(DynamicSimulation);
						(vehicle (leader (_groups # 0))) call FUNCMAIN(AppendCleanupSystemObjects);
						_groups call FUNCMAIN(AppendCleanupSystemObjects);

						// -- Add New Units To Active Unit Array
						_groups apply {(_config # 6) append (units _x)};				
					};

					// -- Be nice to the server
					sleep 1;

				} foreach _sideconfigs;
			};			
			
			sleep 30;
			
			_debug_objs apply {deleteVehicle _x};
		};
	};
};
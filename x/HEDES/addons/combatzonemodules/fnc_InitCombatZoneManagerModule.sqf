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

	// Initialize Variables
	private _combatzone = objNull;
	private _pointmodule = objNull;
	private _pointranpos = [0,0];
	private _config = objNull;
	private _groups = [];
	private _combatlz = objNull;
	private _combatlztrgs = [];
	private _combatlzpos = [0,0];
	private _debug_objs = [];
	private _interval = _this getVariable ["SimulationInterval",120];
	private _disabledmg = _this getVariable ["DisableDamage",true];
	private _playobjective = _this getVariable ["UnitsAlwaysPlayObjective", true];
	private _maxtimeout = 600;


	// Build Side Configuration Settings
	private _sideconfigs = [];

	// Add East
	private _eastSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_EastSpawn" });
	if(count(_eastSpawns) > 0) then 
	{
		_sideconfigs pushback [EAST,_this getVariable ["EastVehicle",""],_this getVariable ["EastUnitPool",""],getPos (selectRandom _eastSpawns),_this getVariable ["EastIsHeli",true],_this getVariable ["EastMaxUnits",80],[],[]];
	};

	// Add West
	private _westSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_WestSpawn" });
	if(count(_westSpawns) > 0) then 
	{
		_sideconfigs pushback [WEST,_this getVariable ["WestVehicle",""],_this getVariable ["WestUnitPool",""],getPos (selectRandom _westSpawns),_this getVariable ["WestIsHeli",true],_this getVariable ["WestMaxUnits",80],[],[]]
	};

	// Add Independent
	private _guerSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_GuerSpawn" });
	if (count(_guerSpawns) > 0) then 
	{
		_sideconfigs pushback [INDEPENDENT,_this getVariable ["GUERVehicle",""],_this getVariable ["GUERUnitPool",[]],getPos (selectRandom _guerSpawns),_this getVariable ["GUERIsHeli",true],_this getVariable ["GUERMaxUnits",80],[],[]];
	}; 

	// Configure trigger area for all combat zone's and lz's.
	private _newtrigger = objNull;
	private _createtriggerfnc = {
		_newtrigger = createtrigger ["emptydetector", position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger setPos (getPos _this);
		_newtrigger enableSimulationGlobal false;
		_this setVariable ["trigger",_newtrigger];
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


	//  Main Loop
	while {_this isNotEqualTo objNull} do 
	{
		if (simulationEnabled _this) then
		{
			// Find new combat zone area.
			_combatzone = selectRandom (_points select {simulationEnabled (_x select 0)});
			_pointmodule = _combatzone # 0;
			_pointranpos = (_combatzone # 1) call BIS_fnc_randomPosTrigger;
			_pointranpos = [_pointranpos, 0, 10] call BIS_fnc_findSafePos;

			// If the conbat zone position is valid, continue.
			if (_pointranpos isNotEqualTo [0,0]) then 
			{
				// Iterate through each side config.
				{		
					_x params ["_side","_cfgvehicle","_unitpool","_spawn","_isHeli","_maxunits","_activeunits","_activehelis"];
					_config = _x;

					// Delete lost heli's.
					{
						{deleteVehicle _x} foreach (crew _x);
						deleteVehicle _x;
					} foreach (_activehelis select {(_x getVariable "starttime") + _maxtimeout < time});
						
					// Filter out dead/null values.
					_config set [6,(_activeunits - [objNull]) select {alive _x}];	
					_config set [7,_activehelis - [objNull] select {alive _x}];

					// Update all unit orders.
					if _playobjective then 
					{
						_grouptoreset = (_activeunits select {isTouchingGround _x} apply {group _x}); 
						_grouptoreset = _grouptoreset arrayIntersect _grouptoreset;
						{[_x, _pointranpos] call BIS_fnc_taskAttack; } foreach _grouptoreset;
					};

					// Get LZ Module Properties
					_combatlz = switch (_side) do 
					{
						case EAST: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_EastLZ"})};
						case WEST: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_WestLZ"})};
						case INDEPENDENT: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_GuerLZ"})};
					};
									
					// Get Combat Zone Landing Area Triggers
					_combatlztrg = _combatlz getVariable "trigger";
					_combatlzpos = _combatlztrg call BIS_fnc_randomPosTrigger;
					_combatlzpos = [_combatlzpos, 0, 10] call BIS_fnc_findSafePos;	

					if !(isNil "HEDES_DEBUG") then 
					{
						_debug_objs pushBack ("VR_3DSelector_01_default_F" createVehicle _combatlzpos);
					};

					// Spawn new units if side not full
					if(count _activeunits < _maxunits && (_combatlzpos isNotEqualTo [0,0])) then
					{
						// Spawn Vehicle With Crew and Fireteams
						_groups = [_side, _cfgvehicle, call compile(_unitpool), _spawn] call FUNCMAIN(SpawnVehicleAndCrew);
						_groups apply {_x allowFleeing 0};
						while {count(units (_groups # 1)) > _maxunits} do 
						{
							deleteVehicle (selectRandom units (_groups # 1));
						};
						units(_groups # 0) apply {_x disableAI "SUPPRESSION"};
						units(_groups # 0) apply {_x disableAI "RADIOPROTOCOL"};
						units(_groups # 0) apply {_x disableAI "MINEDETECTION"};

						// Disable Damage On Heli & Crew If Configured 
						if _disabledmg then 
						{
							units(_groups # 0) apply {_x allowDamage false};
							vehicle (leader (_groups # 0)) allowDamage false;
						};
						
						// Setup Unit and Vehicle Orders						
						(_groups + [_combatlzpos, _spawn, _isHeli]) spawn FUNCMAIN(FlightPlanner);
						[_groups # 1, _pointranpos] call BIS_fnc_taskAttack; 

						// Add timeout tag to heli and push to end of tracking array
						private _vehicle = vehicle (leader (_groups # 0));
						_vehicle setVariable ["starttime",time];
						_activehelis pushBack _vehicle;

						// Add Units To Cleanup
						[_groups # 1, FUNCMAIN(IsPlayersNearGroup), _isHeli] spawn FUNCMAIN(DynamicSimulation);
						(vehicle (leader (_groups # 0))) call FUNCMAIN(AppendCleanupSystemObjects);
						_groups call FUNCMAIN(AppendCleanupSystemObjects);

						// Add New Units To Active Unit Array
						_groups apply {_activeunits append (units _x)};	
						_config set [6,_activeunits];
					};					

				} foreach _sideconfigs;
			};			
			
			_debug_objs apply {deleteVehicle _x};
		};

		sleep _interval;
	};
};